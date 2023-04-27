// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Test {
    uint256 private storedValue;

    event ValueChanged(uint256 newValue);

    constructor(uint256 initialValue) {
        storedValue = initialValue;
        emit ValueChanged(initialValue);
    }

    function set(uint256 newValue) public {
        storedValue = newValue;
        emit ValueChanged(newValue);
    }

    function get() public view returns (uint256) {
        return storedValue;
    }
}
