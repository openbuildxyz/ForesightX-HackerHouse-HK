// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract XToken is ERC20,Ownable{

    address private optionMine;
    address private optionSwap;
    uint private MAX_TOTAL_SUPPLY = 10_0000_0000e18;
    
    constructor(string memory name,string memory sysbol) ERC20(name,sysbol){}

    function setOptionMine(address _mine)public onlyOwner{
        optionMine = _mine;
    }

    function setOptionSwap(address _swap)public onlyOwner{
        optionSwap = _swap;
    }

    function mint(address rec,uint amount)public {
        require(msg.sender == optionMine,"mint: permission denied .");
        require((totalSupply()+amount) <= MAX_TOTAL_SUPPLY,"mint: MAX_TOTAL_SUPPLY error .");
        _mint(rec,amount);
    }

    function burn(address user,uint amount)public {
        require(msg.sender == optionSwap,"burn: permission denied .");
        _burn(user,amount);
    }

    function getMaxTotalSupply()public view returns(uint){
        return MAX_TOTAL_SUPPLY;
    }
}


/*

xToken的实现， 总量固定，增加两个私有的账户，一个是挖矿账户，一个是交易账户，只有这两个账户可以调用mint和burn方法。
在Goerli Testnet上部署的合约地址为：0x87ebc2c45484332318ff37340cfbeaf91034f84d

Token的基础信息如下：
总供应量：10_0000_0000e18;
name： xToken
sysbol XT
*/