//SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.0;

import "./test_lib.sol";

contract Basic is testLib{
    uint private number;
    
    event NumberChanged(uint oldNumber, uint newNumber);

    modifier onlyOwner() {
        require(msg.sender == testOwner, "only owner");
        _;
    }

    constructor() {
        number = 0;
        testOwner = msg.sender;
    }

    function getNumber() public view returns(uint) {
        return number;
    }

    function setNumber(uint newNumber) external onlyOwner{
        emit NumberChanged(number, newNumber);
        number = newNumber;
    }


}