import 'dotenv/config'

import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "./tasks/tasks"

const config: HardhatUserConfig = {
  solidity: "0.8.18",

  defaultNetwork:"hardhat",
  networks: {
    
    localhost:{
      url:"http://127.0.0.1:8545",
   },
    // // testnet
    // testnet: {
    //   url: `https://data-seed-prebsc-1-s2.binance.org:8545/`,
    //   chainId: 97,
    //   accounts: process.env.BNB_PRIVATE_KEY !==undefined
    //   ?[process.env.BNB_PRIVATE_KEY]
    //   :[]
    // },
    
  }
};

export default config;
