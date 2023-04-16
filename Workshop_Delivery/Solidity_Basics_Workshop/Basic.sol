// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.0;

contract MyContract {
    uint256 private myVal;

    function setVal(uint256 newValue) public {
        myVal = newValue;
    }

    function getVal() public view returns (uint256) {
        return myVal;
    }
}
