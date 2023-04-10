//指定solidity编译器版本
pragma solidity ^0.8.0;

//定义合约，类似于一个类
contract MyContract {

    //定义一个状态变量
    uint public myVariable;

    //定义一个函数，用来更新状态变量
    function updateVariable(uint newValue) public {
        myVariable = newValue;
    }

    //定义一个函数，返回状态变量的值
    function getVariable() public view returns (uint) {
        return myVariable;
    }
}

