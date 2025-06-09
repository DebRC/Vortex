require('dotenv').config();
const {
  JsonRpcProvider,
  Wallet,
  Contract,
  keccak256,
  AbiCoder,
  parseUnits
} = require('ethers');

(async () => {
  const RPC_URL = process.env.RPC_URL;
  const RPC_URL_VORTEX = process.env.RPC_URL_VORTEX;
  const PRIVATE_KEY = process.env.PRIVATE_KEY_2;
  const VORTEX_ADDRESS = process.env.VORTEX_CONTRACT_ADDRESS;
  const VORTEX_ABI = require(process.env.VORTEX_ABI_PATH).abi;
  const VERIFIER_ADDRESS = process.env.VERIFIER_CONTRACT_ADDRESS;
  const VERIFIER_ABI = require(process.env.VERIFIER_ABI_PATH).abi;

  const FETCH_INTERVAL = 2000;  // ms
  const VERIFY_INTERVAL = 50;  // ms
  const SUBMIT_INTERVAL = 50;  // ms
  const DELAY_BLOCKS = 2;     // blocks to wait before submit

  const proofs = new Map();

  const provider = new JsonRpcProvider(RPC_URL);
  const wallet = new Wallet(PRIVATE_KEY, provider);
  const provider_vortex = new JsonRpcProvider(RPC_URL_VORTEX);
  const wallet_vortex = new Wallet(PRIVATE_KEY, provider_vortex);
  const verifier_vortex = new Contract(VORTEX_ADDRESS, VORTEX_ABI, wallet);
  const verifier = new Contract(VERIFIER_ADDRESS, VERIFIER_ABI, wallet_vortex);
  const abiCoder = new AbiCoder();

  async function fetchProofs() {
    try {
      let newProofCount = 0;
      const topic = verifier_vortex.interface.getEvent("ProofAnnounced").topic;
      const logs = await provider.getLogs({
        fromBlock: 'latest',
        toBlock: 'latest',
        address: VORTEX_ADDRESS,
        topics: [topic]
      });
      let currBlock = 0;
      for (const log of logs) {
        const { proofId, a, b, c, publicInputs } = verifier_vortex.interface.parseLog(log).args;
        const key = proofId.toString();
        if (proofs.has(key)) continue;
        newProofCount += 1;
        currBlock = log.blockNumber;
        console.log(`[FETCH] Fetched Proof ${key} :: Block ${log.blockNumber}`);
        proofs.set(key, {
          status: "pending",
          blockNumber: log.blockNumber,
          a: a,
          b: b,
          c: c,
          publicInputs: publicInputs
        });
      }
      if (newProofCount > 0) {
        console.log(`[FETCHED] Total Proofs Fetched: ${newProofCount} from Block ${currBlock}`);
      }
    }
    catch (err) {
      console.error("[FETCH-FAIL] Proof Fetch Error ::", err.message);
    }
  }

  async function verifyProofs() {
    const batch = Array.from(proofs.entries())
      .filter(([_, p]) => p.status === "pending");

    if (batch.length === 0) return;
    const baseNonce = await provider_vortex.getTransactionCount(wallet_vortex.address, 'pending');
    const to = VERIFIER_ADDRESS;
    const from = wallet_vortex.address;
    await Promise.all(batch.map(async ([key, p], idx) => {
      p.status = "verifying";  // lock immediately
      // const data  = verifier.interface.encodeFunctionData("verifyProof",[p.a, p.b, p.c, p.publicInputs]);
      // const gasEstimate = await provider_vortex.estimateGas({ to, from, data, nonce: baseNonce + idx });
      const gasEstimate = 494000; // hardcoded gas estimate for now, can be adjusted based on actual usage
      const baseFee = parseUnits("10", "gwei");
      const priority = parseUnits("2", "gwei");
      const maxFee = BigInt(baseFee) + BigInt(priority);
      try {
        const a = [...p.a]; const b = p.b.map(arr => [...arr]); const c = [...p.c]; const publicInputs = [...p.publicInputs];
        const tx = await verifier.verifyProof(a, b, c, publicInputs, {
          from: from,
          nonce: baseNonce + idx,
          gasLimit: gasEstimate,
          maxFeePerGas: maxFee,
          maxPriorityFeePerGas: priority
        });
        console.log(`[VERIFY] Proof ${key} Submitted to Vortex EVM`);
        const rc = await tx.wait(1);
        p.status = "verified";
        p.state = tx.data;
        console.log(`[VERIFY-OK] Proof ${key} Verified in Vortex EVM. L1.5 Gas Used: ${rc.gasUsed.toString()}`);
      } catch (err) {
        console.error(`[VERIFY-FAIL] Proof ${key} FAILED`, err.message);
        p.status = "failed";
        return;
      }
    }));
    let currBlock = await provider.getBlockNumber();
    console.log(`[VERIFIED] ${batch.length} Proof(s) verified within Block ${currBlock}`);
  }

  async function submitProofs() {
    const currentBlock = await provider.getBlockNumber();
    const batch = Array.from(proofs.entries())
      .filter(([key, p]) => {
        if (p.status !== "verified" || p.status === "failed") return false;
        if (p.statusLock) return false; // skip if in-flight
        // check delay window
        if (currentBlock >= p.blockNumber + DELAY_BLOCKS) {
          console.log(`[EXPIRED] Proof ${key} cannot be Submitted`);
          p.status = "failed";
          return false;
        }
        return currentBlock >= p.blockNumber + DELAY_BLOCKS - 1
          && currentBlock <= p.blockNumber + DELAY_BLOCKS;
      });

    if (batch.length === 0) return;

    const baseNonce = await provider.getTransactionCount(wallet.address, 'pending');
    const to = VORTEX_ADDRESS;
    const from = wallet.address;

    await Promise.all(batch.map(async ([key, p], idx) => {
      p.status = "submitting"; // lock
      const state = keccak256(abiCoder.encode(
          ['bytes32'],
          [keccak256(p.state)]
        ));
      // const data  = verifier_vortex.interface.encodeFunctionData("submitState",[key, state]);
      // let gasEstimate = await provider.estimateGas({ to, from, data, nonce: baseNonce + idx });
      const gasEstimate = 25000;

      const baseFee = parseUnits("10", "gwei");
      const priority = parseUnits("2", "gwei");
      const maxFee = BigInt(baseFee) + BigInt(priority);

      try {
        const tx = await verifier_vortex.submitState(key, state, {
          from: from,
          nonce: baseNonce + idx,
          gasLimit: gasEstimate,
          maxFeePerGas: maxFee,
          maxPriorityFeePerGas: priority
        });
        const rc = await tx.wait(1);
        console.log(`[STATE-SUBMIT] State Submit of Proof ${key} Confirmed :: Block ${rc.blockNumber}. Gas Used: ${rc.gasUsed.toString()}`);
        p.status = "submitted";
      } catch (err) {
        console.error(`[STATE-SUBMIT-FAIL] State Submit of Proof ${key} FAILED`, err.message);
      }
    }));
    let currBlock = await provider.getBlockNumber();
    console.log(`[STATE-SUBMITTED] ${batch.length} States Submitted in Block ${currBlock}`);
  }

  // ─── Kick off loops ───────────────────────────────────────
  console.log("Vortex Validator Started...");
  setInterval(fetchProofs, FETCH_INTERVAL);
  let verifying = false;
  (async function verifyLoop() {
    while (true) {
      if (!verifying) {
        verifying = true;
        try {
          await verifyProofs();
        } catch (err) {
          console.error("[VERIFY LOOP] Unexpected error:", err);
        } finally {
          verifying = false;
        }
      }
      await new Promise(resolve => setTimeout(resolve, VERIFY_INTERVAL));
    }
  })();
  let stateSubmitting = false;
  (async function submitLoop() {
    while (true) {
      if (!stateSubmitting) {
        stateSubmitting = true;
        try {
          await submitProofs();
        } catch (err) {
          console.error("[SUBMIT-STATE LOOP] Unexpected error:", err);
        } finally {
          stateSubmitting = false;
        }
      }
      await new Promise(resolve => setTimeout(resolve, SUBMIT_INTERVAL));
    }
  })();
})();