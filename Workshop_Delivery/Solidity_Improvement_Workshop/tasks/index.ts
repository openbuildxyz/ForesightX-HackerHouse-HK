import { task } from "hardhat/config";
import { storeAddress, verifyingContract } from "../scripts/helper";
import {
  LPToken__factory,
  RewardToken__factory,
  LiquidityMining__factory,
} from "../typechain-types";

task("deploy", "Deploy LiquidityMining contracts").setAction(async (_, hre) => {
  const { network } = hre;
  const [dev] = await hre.ethers.getSigners();

  console.log("Deploying to ", network.name, " by ", dev.address);

  const lpToken = await new LPToken__factory(dev).deploy();
  storeAddress(network.name, "lpToken", lpToken.address);
  await lpToken.deployed();
  await verifyingContract(hre, lpToken.address);
  // await verifyingContract(hre, "0xAF8E887E382EE8B820Cab8b8fCbfa66125cAC6A5");

  const rewardToken = await new RewardToken__factory(dev).deploy();
  storeAddress(network.name, "rewardToken", rewardToken.address);
  await rewardToken.deployed();
  await verifyingContract(hre, rewardToken.address);

  const liquidityMining = await new LiquidityMining__factory(dev).deploy(
    rewardToken.address
  );
  storeAddress(network.name, "liquidityMining", liquidityMining.address);
  await liquidityMining.deployed();
  await verifyingContract(hre, liquidityMining.address, [rewardToken.address]);

  await rewardToken.connect(dev).transferOwnership(liquidityMining.address);
});
