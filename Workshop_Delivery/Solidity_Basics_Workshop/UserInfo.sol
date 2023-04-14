// SPDX-License-Identifier: MIT


pragma solidity ^0.8.9;


contract UserInfo {
    
    string public name;
    string private phone;

    constructor(string memory _name, string memory _phone){
        name = _name;
        phone = phone;
    }


    function showPhone()public view returns(string memory){
        return phone;
    }

}

/*

BaseContract
UserInfo.sol 
Goerli testnet : 0xc985e17edd0299de10e28eadac68c7e5bef32c79

*/