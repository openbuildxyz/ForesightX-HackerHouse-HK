// SPDX-License-Identifier: MIT


pragma solidity ^0.8.9;


contract TestArray {

    address[] public dataArray;

    constructor(){
        dataArray = new address[](0);
    }

    function addData(address newElement) public {
        dataArray.push(newElement);
    }

    function removeData(uint256 index)public {
        if(index < dataArray.length){
            dataArray[index] = dataArray[dataArray.length-1];
            dataArray.pop();
        }
    }

    function check(uint256 index)public view returns(address){
        return dataArray[index];
    }

    function getElementAmount()public view returns(uint256){
        return dataArray.length;
    }

}


/*

    在Goerli Testnet上部署的合约地址为：0x001be8a113de80026afd53f579c9ae07b6c6c0f5
    通过数组的形式，在链上进行数据操作。

*/