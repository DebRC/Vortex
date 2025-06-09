const hre = require("hardhat");

async function main() {
  // Deploy Verifier contract
  const Verifier = await hre.ethers.getContractFactory("Groth16Verifier");
  const verifier = await Verifier.deploy();
  await verifier.waitForDeployment();
  const verifierAddress = await verifier.getAddress();
  console.log("Verifier deployed to:", verifierAddress);

  const VerifierVortex = await hre.ethers.getContractFactory("VerifierVortex");
  const verifierVortex = await VerifierVortex.deploy();
  await verifierVortex.waitForDeployment();
  const verifierVortexAddress = await verifierVortex.getAddress();
  console.log("VerifierVortex deployed to:", verifierVortexAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});