// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.10;
import {ERC20} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

/**
 * testnet: BSC testnet
 * contract address: 0x066973a4784d5f7bb4F01633516c779003929448
 * creator address: 0xcbeE6DdA2347C0EC0e45870d4D6cf3526a2E319C
 * @param initialSupply 100000000
 */
contract Test is ERC20 {
    constructor(uint256 initialSupply) ERC20("HacksonTest", "LYF") {
        _mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}