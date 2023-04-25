import { expect } from "chai";
import { ethers } from "hardhat";
import { Contract,ContractFactory } from "ethers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";


describe("Mypunks Test", function () {
  let MyPunksFactoty:ContractFactory;
  let myPunks: Contract;
  let admin: SignerWithAddress;
  let alice:SignerWithAddress;
  let bob: SignerWithAddress;

  beforeEach(async function () {
    [admin, alice, bob] = await ethers.getSigners();
    
    //获得 MyPunksFactoty
    MyPunksFactoty = await ethers.getContractFactory("MyPunks");
    
    //部署合约
    myPunks = await MyPunksFactoty.deploy();
    await myPunks.deployed()
  });

  describe("Deployment", function(){
    it("should have the correct owner",async function ()  {
      expect(await myPunks.owner()).to.equal(admin.address);
    });

    it("should have the correct intial value",async function ()  {
      expect(await myPunks.counter()).to.equal(0);
    });
  });

  describe("Mint", function() {
    it("should be able to add a whitelist address", async function () {
      await expect(myPunks.addWhitelist(alice.address))
      .to.emit(myPunks,"NewWhitelistAdded")
      .withArgs(alice.address);

      expect(await myPunks.isWhitelisted).to.equal(true);
    })

    it("should be able to mint a token" ,async function () {
      await myPunks.addWhitelist(alice.address);

      await expect(myPunks.connect(alice).mint())
      .to.emit(myPunks,"NewPunkMinted")
      .withArgs(alice.address,1);

      expect(await myPunks.counter()).to.equal(1);
      expect(await myPunks.balanceOf(alice.address)).to.equal(1);
      expect(await myPunks.userTokenId(alice.address)).to.equal(1);
    });

     it ("should not be able to mint more than one token", async function(){
      await myPunks.addWhitelist(alice.address);
      await myPunks.connect(alice).mint();

      //  Mint NFT by alice again
      await expect(myPunks.connect(alice).mint()).to.be.revertedWith("Already minted!")
     })
  });

  describe("Transfer",function() {
    beforeEach(async function()  {
      await myPunks.addWhitelist(alice.address);
      await myPunks.connect(alice).mint();
    });

    it("should not be able to trnasfer myPunks",async function(){
      const zoreAdress = "0x0000000000000000000000000000000000000000";
      await expect(
        myPunks.connect(alice).transferFrom(alice.address,zoreAdress,1)
        .to.be.revertedWith("Transfer not allowed!")
      )
    });
  })

  describe("Burn", function(){
    beforeEach(async function()  {
      await myPunks.addWhitelist(alice.address);
      await myPunks.connect(alice).mint();
    });

    it("should be able to burn nft by owner", async function(){
      await expect(myPunks.connect(admin).burn(alice.address))
      .to.emit(myPunks, "PunkBurned")
      .withArgs(alice.address,1);
    })

    it("should not be able to burn nft by non-owner",async function() {
       await expect(myPunks.connect(bob).burn(alice.address).to.be.revertedWith(
        "Not owner!"
       ))
    })
  })


})