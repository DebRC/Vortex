import os, random
import subprocess
from web3 import Web3
from eth_account import Account
from concurrent.futures import ThreadPoolExecutor, as_completed
import csv

from dotenv import load_dotenv

load_dotenv("../.env")

PER_TXN_GAS = int(os.getenv("PER_TXN_GAS"))
NUM_TXNS = int(os.getenv("GAS_LIMIT")) // PER_TXN_GAS
NUM_ROUNDS = int(os.getenv("NUM_ROUNDS"))
PROFILING_NODE_IPC_PATH = os.getenv("PROFILING_NODE_IPC_PATH")
SLOT_DURATION = int(os.getenv("CPU_PROFILE_INTERVAL"))
READINGS_DIR = os.getenv("READINGS_DIR")
RPC_URL = os.getenv("RPC_URL")
PRIVATE_KEY = [
    os.getenv("PRIVATE_KEY_1"),
    os.getenv("PRIVATE_KEY_2"),
    os.getenv("PRIVATE_KEY_3"),
]
os.makedirs(READINGS_DIR, exist_ok=True)
DEVNULL = subprocess.DEVNULL

w3 = Web3(Web3.HTTPProvider(RPC_URL))

acct1Key = random.choice(PRIVATE_KEY)
acct2Key = random.choice(PRIVATE_KEY)
while acct1Key == acct2Key:
    acct2Key = random.choice(PRIVATE_KEY)
acct1 = Account.from_key(acct1Key)
acct2 = Account.from_key(acct2Key)

cpu_profile_file = ""

def run_command(cmd):
    result = subprocess.run(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
    )
    if result.returncode != 0:
        print(f"Error :: {result.stderr}")
        raise Exception("Command failed")
    return result.stdout

def start_cpu_profiling():
    abs_prof = os.path.abspath(os.path.join(READINGS_DIR, f"cpu.prof"))
    global cpu_profile_file
    cpu_profile_file = abs_prof

    subprocess.run(
        [
            "geth",
            "--exec",
            "try { debug.stopCPUProfile(); } catch (e) {}",
            "attach",
            PROFILING_NODE_IPC_PATH,
        ],
        check=False,
        stdout=DEVNULL,
        stderr=DEVNULL,
    )

    subprocess.run(
        [
            "geth",
            "--exec",
            f'debug.startCPUProfile("{abs_prof}")',
            "attach",
            PROFILING_NODE_IPC_PATH,
        ],
        check=True,
        stdout=DEVNULL,
        stderr=DEVNULL,
    )

def stop_cpu_profiling():
    subprocess.run(
        ["geth", "--exec", "debug.stopCPUProfile()", "attach", PROFILING_NODE_IPC_PATH],
        check=True,
        stdout=DEVNULL,
        stderr=DEVNULL,
    )

def sign_txn(nonce):
    base_fee = w3.to_wei(10, "gwei")
    tip = w3.to_wei(2, "gwei")
    max_fee = int(base_fee) + tip
    transferValue = w3.to_wei(0.1, "ether")
    est = w3.eth.estimate_gas(
        {
            "from": acct1.address,
            "to": acct2.address,
            "value": transferValue,
        }
    )

    print(f"Estimated Gas for Txn :: {est}, Nonce :: {nonce}")

    txn = {
        "nonce": nonce,
        "to": acct2.address,
        "value": transferValue,
        "gas": est,
        "maxFeePerGas": max_fee,
        "maxPriorityFeePerGas": tip,
        "chainId": 32382,
        "type": "0x2",
    }
    signed_tx = w3.eth.account.sign_transaction(txn, acct1Key)
    return signed_tx

def sign_txns(n):
    signed_txns = []
    base_nonce = w3.eth.get_transaction_count(acct1.address, "pending")
    for i in range(n):
        signed_txns.append(sign_txn(base_nonce + i))
    return signed_txns

def submit_txns(signed_txns):
    tx_hash_list = []
    with ThreadPoolExecutor(max_workers=50) as executor:
        futures = [
            executor.submit(w3.eth.send_raw_transaction, signed_tx.raw_transaction)
            for signed_tx in signed_txns
        ]
        for future in futures:
            try:
                tx_hash = future.result()
                tx_hash_list.append(tx_hash)
                print(f"Txn Submitted :: 0x{tx_hash.hex()}")
            except Exception as e:
                print(f"Error Submitting Txn: {e}")
    return tx_hash_list

def confirm_txns(tx_hash_list):
    confirmed_txns = 0
    for tx_hash in tx_hash_list:
        try:
            receipt = w3.eth.wait_for_transaction_receipt(tx_hash, timeout=300)
            print(
                f"Transaction Confirmed :: 0x{tx_hash.hex()}, Gas Used :: {receipt.gasUsed}, Block :: {receipt.blockNumber}"
            )
            confirmed_txns += 1
        except Exception as e:
            print(f"Txn Timeout or Error :: 0x{tx_hash.hex()}\n{e}")
    print(f"{confirmed_txns} Transactions Confirmed.")

def generate_results(start_block, end_block):
    block_details = []
    for blk in range(start_block, end_block + 1):
        block = w3.eth.get_block(blk, full_transactions=True)
        tx_count = len(block.transactions)
        gas_used = block.gasUsed
        base_fee = block.get("baseFeePerGas", 0)
        block_details.append(
            {
                "blockNumber": blk,
                "gasUsed": gas_used,
                "baseFeePerGas(wei)": base_fee,
                "txCount": tx_count,
            }
        )
    while block_details and block_details[0]["txCount"] == 0:
        block_details.pop(0)
    while block_details and block_details[-1]["txCount"] == 0:
        block_details.pop()
        
    total_blocks = len(block_details)
    
    gas_used_per_block = sum(b["gasUsed"] for b in block_details)//total_blocks

    with open(os.path.join(READINGS_DIR, "block_details.csv"), "w", newline="") as f:
        writer = csv.DictWriter(
            f, fieldnames=["blockNumber", "gasUsed", "baseFeePerGas(wei)", "txCount"]
        )
        writer.writeheader()
        writer.writerows(block_details)

    block_tps = (gas_used_per_block / SLOT_DURATION)    
    
    with open(os.path.join(READINGS_DIR, "cpu.gif"), "wb") as out:
        subprocess.run(
            ["go", "tool", "pprof", "-gif", cpu_profile_file],
            stdout=out,
            check=True
        )
    result = subprocess.run(
        ["go", "tool", "pprof", "-text", cpu_profile_file],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
    )
    state_process_evm_time = 0.0
    for line in result.stdout.splitlines():
        if "github.com/ethereum/go-ethereum/core.(*StateProcessor).Process" in line:
            try:
                parts = line.strip().split()
                if parts[3][-2:]=='ms':
                    state_process_evm_time=float(parts[3][:-2])/1000
                else:
                    state_process_evm_time=float(parts[3][:-1])
            except:
                print(f"Error parsing CPU profile {cpu_profile_file}")
    
    cpu_usage = state_process_evm_time / (total_blocks*SLOT_DURATION)
    
    print("======== FINAL REPORT ========")
    print(f"Blocks Used: {total_blocks}")
    print(f"Gas Used per Block: {gas_used_per_block/(10**6):.2f} Million")
    print(f"Gas-Based Throughput: {block_tps/(10**6):.2f} Million Gas/sec")
    print(f"Average CPU Usage by Execution Client (%): {cpu_usage*100:.2f}%")
    print(f"Average CPU Usage by Execution Client (Time): {cpu_usage*SLOT_DURATION:.2f} sec(s) out of {SLOT_DURATION} secs")
    print("======== END ========")


def main():
    signed_txns = sign_txns(NUM_ROUNDS*NUM_TXNS)
    start_block = w3.eth.block_number
    start_cpu_profiling()
    for i in range(0,len(signed_txns), NUM_TXNS):
        signed_txns_batch = signed_txns[i:i+NUM_TXNS]
        tx_hash_list = submit_txns(signed_txns_batch)
        confirm_txns(tx_hash_list)
    stop_cpu_profiling()
    end_block = w3.eth.block_number
    generate_results(start_block, end_block)

if __name__ == "__main__":
    main()
