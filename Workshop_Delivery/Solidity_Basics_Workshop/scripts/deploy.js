const { ethers } = require('hardhat');
const { deployContract } = require('./utils');

async function main() {
  // Deploy Token contract
  const Token = await deployContract('Token');

  // Deploy LiquidityMining contract
  const LiquidityMining = await deployContract('LiquidityMining');

  console.log('Token contract address:', Token.address);
  console.log('LiquidityMining contract address:', LiquidityMining.address);
  console.log('Deployed contracts successfully.');
}

main()
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
