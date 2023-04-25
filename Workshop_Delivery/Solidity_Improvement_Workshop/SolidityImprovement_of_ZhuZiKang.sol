// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Creater 0x403d367Ad41446F221e04A2f1b93885f0A3a4530
// BNB 0xae7b7C723ecEFec6149Cab8b24C0116f5557E266
// Deploy with remix
// @param initialSupply 1000000

contract Imporvement is ERC20 {
    constructor(uint256 initialSupply) ERC20("Solidity Imporvement Token", "SIT") {
        _mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
