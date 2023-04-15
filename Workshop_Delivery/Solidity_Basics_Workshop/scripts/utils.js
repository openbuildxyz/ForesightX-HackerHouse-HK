const { ethers } = require('hardhat');

async function deployContract(name, args) {
  const factory = await ethers.getContractFactory(name);
  const contract = await factory.deploy(...args);
  await contract.deployed();
  return contract;
}

module.exports = {
  deployContract,
};
