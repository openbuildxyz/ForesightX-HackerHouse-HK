import { ethers, network } from "hardhat";
import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("LiquidityMining Test", function () {
  function toWei(amount: number) {
    return ethers.utils.parseUnits(amount.toString(), 18);
  }

  const MINT_AMOUNT = toWei(100);
  const PID = 0;

  async function deployLiquidityMiningFixture() {
    const [dev, alice] = await ethers.getSigners();

    const LPToken = await ethers.getContractFactory("LPToken", dev);
    const lpToken = await LPToken.deploy();

    const RewardToken = await ethers.getContractFactory("RewardToken", dev);
    const rewardToken = await RewardToken.deploy();

    const LiquidityMining = await ethers.getContractFactory("LiquidityMining");
    const liquidityMining = await LiquidityMining.deploy(rewardToken.address);

    await rewardToken.connect(dev).transferOwnership(liquidityMining.address);
    await liquidityMining.connect(dev).add(lpToken.address);
    await lpToken.connect(alice).approve(liquidityMining.address, MINT_AMOUNT);

    return { dev, alice, liquidityMining, lpToken, rewardToken };
  }

  async function mineBlocks(blocks: number) {
    for (let i = 0; i < blocks; i++) {
      await network.provider.send("evm_mine");
    }
  }

  async function increaseTime(seconds: number) {
    await network.provider.send("evm_increaseTime", [seconds]);
  }

  describe("Deployment", function () {
    it("正确的名称与符号", async function () {
      const { lpToken, rewardToken } = await loadFixture(
        deployLiquidityMiningFixture
      );

      expect(await lpToken.name()).to.equal("LPToken");
      expect(await lpToken.symbol()).to.equal("LP");

      expect(await rewardToken.name()).to.equal("RewardToken");
      expect(await rewardToken.symbol()).to.equal("RD");
    });

    it("正确的所有者", async function () {
      const { liquidityMining, rewardToken, dev } = await loadFixture(
        deployLiquidityMiningFixture
      );

      expect(await liquidityMining.owner()).to.equal(dev.address);
      expect(await rewardToken.owner()).to.equal(liquidityMining.address);
    });
  });

  describe("Mint", function () {
    it("正确铸造LPToken", async function () {
      const { lpToken, alice } = await loadFixture(
        deployLiquidityMiningFixture
      );

      await expect(lpToken.connect(alice).mint(alice.address, MINT_AMOUNT))
        .to.emit(lpToken, "Transfer")
        .withArgs(ethers.constants.AddressZero, alice.address, MINT_AMOUNT);

      expect(await lpToken.balanceOf(alice.address)).to.equal(MINT_AMOUNT);
    });
  });

  describe("Deposit & Withdraw", function () {
    it("正确存款", async function () {
      const { liquidityMining, lpToken, alice } = await loadFixture(
        deployLiquidityMiningFixture
      );

      await lpToken.connect(alice).mint(alice.address, MINT_AMOUNT);
      await expect(liquidityMining.connect(alice).deposit(PID, MINT_AMOUNT))
        .to.emit(liquidityMining, "Deposit")
        .withArgs(alice.address, PID, MINT_AMOUNT);

      expect(await lpToken.balanceOf(alice.address)).to.equal(0);
    });

    it("正确取款并获取奖励", async function () {
      const { liquidityMining, lpToken, rewardToken, alice } =
        await loadFixture(deployLiquidityMiningFixture);

      await lpToken.connect(alice).mint(alice.address, MINT_AMOUNT);
      await expect(liquidityMining.connect(alice).deposit(PID, MINT_AMOUNT))
        .to.emit(liquidityMining, "Deposit")
        .withArgs(alice.address, PID, MINT_AMOUNT);
      expect(await rewardToken.balanceOf(alice.address)).to.equal(0);

      await increaseTime(60 * 60 * 24); // 模拟增加一天时间
      await mineBlocks(10); // 挖掘了10个块

      await expect(liquidityMining.connect(alice).withdraw(PID, MINT_AMOUNT))
        .to.emit(liquidityMining, "Withdraw")
        .withArgs(alice.address, PID, MINT_AMOUNT);

      expect(await lpToken.balanceOf(alice.address)).to.equal(MINT_AMOUNT);
      expect(await rewardToken.balanceOf(alice.address)).to.be.gt(0);
    });
  });
});
