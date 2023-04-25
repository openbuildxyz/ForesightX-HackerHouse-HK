import 'dotenv/config'

import { HardhatUserConfig } from "hardhat/config";
import '@openzeppelin/hardhat-upgrades';
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.18",

  defaultNetwork:"hardhat",
  networks: {

    localhost:{
       url:"http://127.0.0.1:8545",
    },
    // testnet
    testnet: {
      url: `https://eth-sepolia.public.blastapi.io/`,
      chainId: 11155111,
      accounts: process.env.BNB_PRIVATE_KEY !==undefined
      ?[process.env.BNB_PRIVATE_KEY]
      :[]
    },
    
  }
};

export default config;

