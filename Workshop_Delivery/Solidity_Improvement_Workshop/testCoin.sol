// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;

import "./ERC20.sol";

contract testCoin is ERC20 {
    constructor() ERC20("testCoin", "tc"){
        
    }
}