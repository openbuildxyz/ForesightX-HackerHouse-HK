
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

pragma solidity ^0.8.9;

contract Planet is ERC20 {

    constructor()ERC20("MetaPlanet","MP"){
    }

    function mint(uint amount)public returns(uint totalAmount){
        _mint(msg.sender,amount);
    }

    function burn(uint amount) public returns(uint totalAmount){
        _burn(msg.sender,amount);
    }
}


/*

BaseContract
UserInfo.sol 
Goerli testnet : 0xfe164d079b93abeeaa39cee7ce421d1835f7b5ae

*/
