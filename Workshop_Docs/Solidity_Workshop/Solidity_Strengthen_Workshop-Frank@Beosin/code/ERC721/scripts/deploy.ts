import { ethers } from "hardhat";

async function main() {
  const MyPunks = await ethers.getContractFactory("MyPunks");
  const myPunks = await MyPunks.deploy();

  await myPunks.deployed();

  console.log(
    `Deployed MyPunks to :${myPunks.address} with ${myPunks.deployTransaction.hash}` 
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
