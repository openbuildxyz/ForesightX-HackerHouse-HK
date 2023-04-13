pragma solidity ^0.8.10;

contract Test {
    address private _owner;
    uint256 private _value;

    event ValueSet(address indexed user, uint256 value);
    error NotOwner(address sender);

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner {
        if(msg.sender != _owner) {
            revert NotOwner(msg.sender);
        }
        _;
    }

    function getValue() external view returns (uint256) {
        return _value;
    }

    function setValue(uint256 value_) public onlyOwner returns (uint256) {
        return _setValue(value_);
    }

    function _setValue(uint256 value_) private returns (uint256) {
        _value = value_;
        emit ValueSet(msg.sender, value_);
        return _value;
    }
}