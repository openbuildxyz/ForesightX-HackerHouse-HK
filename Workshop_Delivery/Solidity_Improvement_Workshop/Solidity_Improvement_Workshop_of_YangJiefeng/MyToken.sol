pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("My Token", "YJF") {
        _mint(msg.sender, initialSupply);
    }
}
// 在 BNB Chain 的 testnet 上发布了这个合约，
// 
// 部署的合约地址：
// 0x6Ddc97A3225f4F4F8e8F0C6f8cb153AED9684f86
// 
// 初始供应量为 10000000.000000000000000000 个（精度为 18 位小数）。
// 代币符号 YJF
