import { ethers,upgrades } from "hardhat";

async function main() {

  // Deploying
  const MyPunksUpgradeable = await ethers.getContractFactory("MyPunks");
  const myPunksUpgradeable = await upgrades.deployProxy(MyPunksUpgradeable);

  await myPunksUpgradeable.deployed();

  console.log(
    `Deployed MyPunks to :${myPunksUpgradeable.address} with ${myPunksUpgradeable.deployTransaction.hash}` 
  );

    // Upgrading
    const MyPunksUpgradeableV2 = await ethers.getContractFactory("MyPunksUpgradeableV2");
    const myPunksUpgradeableV2 = await upgrades.upgradeProxy(myPunksUpgradeable.address, MyPunksUpgradeableV2);

    console.log(
      `Deployed MyPunks to :${myPunksUpgradeableV2.address} with ${myPunksUpgradeableV2.deployTransaction.hash}` 
    );

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
