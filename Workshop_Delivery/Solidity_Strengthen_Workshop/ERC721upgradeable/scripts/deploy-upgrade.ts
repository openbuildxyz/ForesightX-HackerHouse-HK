import {ethers, upgrades} from "hardhat";

async function sleep(number: number) {
    return new Promise((resolve) => setTimeout(resolve, number));
}

async function main() {
    const [deployer] = await ethers.getSigners();
    const receiver = {
        address: '0x0000000000000000000000000000000000000001'
    }
    // 1. deploy
    const MyNFTUpgradeable = await ethers.getContractFactory("MyNFTUpgradeable");
    const myNFTUpgradeable = await upgrades.deployProxy(MyNFTUpgradeable);
    await myNFTUpgradeable.deployed();

    console.log(`Deployed MyNFT to :${myNFTUpgradeable.address} on ${myNFTUpgradeable.deployTransaction.hash}`);
    console.log('version', await myNFTUpgradeable.version());

    // add whitelist
    let tx = await myNFTUpgradeable.addWhitelist(deployer.address)
    await tx.wait(1);
    console.log('add whitelist', deployer.address, 'on', tx.hash);

    // mint
    tx = await myNFTUpgradeable.mint()
    await tx.wait(1);
    console.log('minted', deployer.address, 'on', tx.hash);

    // transfer
    tx = await myNFTUpgradeable.transferFrom(deployer.address, receiver.address, 0)
    await tx.wait(1);
    console.log('transfer from', deployer.address, 'to', receiver.address, 'tokenId', 0, 'on', tx.hash);

    // 2. upgrade
    const MyNFTUpgradeableV2 = await ethers.getContractFactory("MyNFTUpgradeableV2");
    await upgrades.upgradeProxy(myNFTUpgradeable.address, MyNFTUpgradeableV2);

    await sleep(10000);
    console.log(`Upgrade to myNFTUpgradeableV2`,);
    console.log('version', await myNFTUpgradeable.version());

    // add whitelist
    tx = await myNFTUpgradeable.addWhitelist(deployer.address)
    await tx.wait(1);
    console.log('after upgrade, add whitelist', deployer.address, 'on', tx.hash);

    // mint
    tx = await myNFTUpgradeable.mint()
    await tx.wait(1);
    console.log('after upgrade, minted', deployer.address, 'on', tx.hash);

    // transfer
    tx = await myNFTUpgradeable.transferFrom(deployer.address, receiver.address, 1)
    await tx.wait(1);
    console.log('after upgrade, transfer from', deployer.address, 'to', receiver.address, 'tokenId', 1, 'on', tx.hash);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
