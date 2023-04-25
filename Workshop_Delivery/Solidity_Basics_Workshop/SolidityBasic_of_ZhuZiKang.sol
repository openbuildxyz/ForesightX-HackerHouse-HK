// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract Basic {
    uint256 public value;

    function setValue(uint256 _value) public onlyOwner {
        return _setValue(_value);
    }

    function _setValue(uint256 _value) private {
        value = _value;
    }

    function getValue() public view returns (uint256) {
        return value;
    }

    constructor() {
        owner = msg.sender;
    }
    
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }
}