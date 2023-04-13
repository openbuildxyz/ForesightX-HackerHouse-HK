// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LPToken is ERC20 {
    constructor() ERC20("LPToken", "LP") {}

    function mint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }
}
