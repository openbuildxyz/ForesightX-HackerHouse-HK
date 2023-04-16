import { HardhatUserConfig } from "hardhat/config";
import '@openzeppelin/hardhat-upgrades';
import "@nomicfoundation/hardhat-toolbox";
import 'dotenv/config'

const config: HardhatUserConfig = {
  solidity: "0.8.18",

  defaultNetwork:"hardhat",
  networks: {

    localhost:{
       url:"http://127.0.0.1:8545",
    },
    // testnet
    testnet: {
      url: `https://data-seed-prebsc-1-s1.binance.org:8545/`,
      accounts: [process.env.PRIVATE_KEY]
    },
    
  }
};

export default config;

