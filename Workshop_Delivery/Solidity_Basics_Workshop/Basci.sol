pragma solidity >=0.4.22 <0.9.0;

// Simple storage contract
contract BasicStorage {
    uint private data;

    function setData(uint value) public {
        data = value;
    }

    function getData() public view returns (uint) {
        return data;
    }
}

// Arithmetic operations contract
contract ArithmeticOps {
    constructor() public {
    }

    function sumResult() public view returns (uint) {
        uint num1 = 1;
        uint num2 = 2;
        uint result = num1 + num2;
        return result;
    }
}

// Address and balance contract
contract AddressBalance {
    address addr1 = 0x212;
    address myAddr = address(this);

    function transferFunds() public {
        if (addr1.balance < 10 && myAddr.balance >= 10) {
            addr1.transfer(10);
        }
    }
}

// Scope testing contract
contract ScopeTest {
    uint public pubData = 30;
    uint internal intData = 10;

    function modifyPubData() public returns (uint) {
        pubData = 3;
        return pubData;
    }
}

// Inheritance and modifiers contract
contract InheritanceModifier is ScopeTest {
    function modifyIntData() public returns (uint) {
        intData = 3;
        return intData;
    }

    function computeResult() public view returns (uint) {
        uint a = 1;
        uint b = 2;
        uint result = a + b;
        return pubData;
    }
}

// Modifiers contract
contract Modifiers {
    address owner;

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier withCost(uint price) {
        require(msg.value >= price);
        _;
    }
}
