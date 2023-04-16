// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;

import "./ERC20.sol";

contract MyCoin is ERC20 {
    constructor() ERC20("MyCoin", "MyCoin"){
        _mint(msg.sender, 12345678 * 1e18);
    }
}
