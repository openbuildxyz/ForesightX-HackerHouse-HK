import { task } from "hardhat/config";
import myPunksjson from '../artifacts/contracts/MyPunks.sol/MyPunks.json';

task("deploy", "Deploy MyPunks contract").setAction(async (_, hre) => {
  const { network } = hre;

  const [dev_account] = await hre.ethers.getSigners();

  console.log(
    "Deploying mypunks contract to network",
    network.name,
    "by",
    dev_account.address
  )

  const MyPunks = await hre.ethers.getContractFactory("MyPunks");
  const myPunks = await MyPunks.deploy();

  await myPunks.deployed();

  console.log(
    `Deployed MyPunks to :${myPunks.address} with ${myPunks.deployTransaction.hash}`
  );

})

task("addWhitelist", "Add a new whitelist address")
  .addParam("address", "The address to be added")
  .setAction(async (taskArgs, hre) => {
    const [dev_account] = await hre.ethers.getSigners();
    const MYPUNKS_ADDRESS = "Your MYPUNKS_ADDRESS";
    const myPunks = await new hre.ethers.Contract(MYPUNKS_ADDRESS, JSON.stringify(myPunksjson.abi), dev_account);

    const tx = await myPunks.addWhitelist(taskArgs.address);
    console.log("Tx details: ", await tx.wait());
  });

task("mint", "Add a new whitelist address").setAction(async (_, hre) => {
  const [, alice] = await hre.ethers.getSigners();
  const MYPUNKS_ADDRESS = "Your MYPUNKS_ADDRESS";

  const myPunks = await new hre.ethers.Contract(MYPUNKS_ADDRESS, JSON.stringify(myPunksjson.abi), alice);

  const tx = await myPunks.connect(alice).mint();
  console.log("Tx details: ", await tx.wait());
});
