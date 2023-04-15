pragma solidity ^0.8.4;

import "./Token.sol";

contract LiquidityMining {
    Token public token;

    struct UserInfo {
        uint256 amount;
        uint256 rewardDebt; 
    }

    struct PoolInfo {
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accRewardPerShare; 
    }

    uint256 public rewardPerBlock = 1000;
    uint256 public totalAllocPoint = 0;

    PoolInfo[] public poolInfo;
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;

    constructor(Token _token) {
        token = _token;
    }

    function add(uint256 _allocPoint) public {
        poolInfo.push(PoolInfo({
            allocPoint: _allocPoint,
            lastRewardBlock: block.number,
            accRewardPerShare: 0
        }));
        totalAllocPoint += _allocPoint;
    }

    function updateRewardPerBlock(uint256 _rewardPerBlock) public {
        rewardPerBlock = _rewardPerBlock;
    }

    function pendingReward(uint256 _pid, address _user) external view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accRewardPerShare = pool.accRewardPerShare;
        uint256 tokenSupply = token.totalSupply() - totalAllocPoint;
        if (block.number > pool.lastRewardBlock && tokenSupply != 0) {
            uint256 blocks = block.number - pool.lastRewardBlock;
            uint256 reward = blocks * rewardPerBlock * pool.allocPoint / totalAllocPoint;
            accRewardPerShare += reward * 1e12 / tokenSupply;
        }
        return user.amount * accRewardPerShare / 1e12 - user.rewardDebt;
    }

    function deposit(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        if (user.amount > 0) {
            uint256 pending = user.amount * pool.accRewardPerShare / 1e12 - user.rewardDebt;
            token.transfer(msg.sender, pending);
        }
        token.transfer(address(this), _amount);
        user.amount += _amount;
        user.rewardDebt = user.amount * pool.accRewardPerShare / 1e12;
    }

    function withdraw(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(user.amount >= _amount, "Withdraw amount is greater than deposit");
        updatePool(_pid);
        uint256 pending = user.amount * pool.accRewardPerShare / 1e12 - user.rewardDebt;
        token.transfer(msg.sender, pending);
        user.amount -= _amount;
        user.rewardDebt = user.amount * pool.accRewardPerShare / 1e12;
        token.transfer(msg.sender, _amount);
    }

    function updatePool(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 tokenSupply = token.totalSupply() - totalAllocPoint;
        if (tokenSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 blocks = block.number - pool.lastRewardBlock;
        uint256 reward = blocks * rewardPerBlock * pool.allocPoint / totalAllocPoint;
        pool.accRewardPerShare += reward * 1e12 / tokenSupply;
        pool.lastRewardBlock = block.number;
    }
}
