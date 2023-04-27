// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./RewardToken.sol";

contract LiquidityMining is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct UserInfo {
        uint256 amount; // 用户提供的LPToken数量
        uint256 rewardDebt; //奖励债务。 从池子开始到用户存入的这段时间，是用户不能领取的部分。为了最终计算用户可以领取奖励用。
    }

    struct PoolInfo {
        IERC20 lpToken; // lpToken的地址
        uint256 allocationPoint; // 按区块分配, 分配点位数量
        uint256 lastRewardBlock; // 最新的奖励区块
        uint256 accumulastedPerShare; // 累计的每次收益
    }

    RewardToken public rewardToken;
    PoolInfo[] public poolInfos;
    mapping(uint256 => mapping(address => UserInfo)) public userInfoMap;
    uint256 public totalAllocationPoint = 0;
    uint256 public startBlock = 0;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);

    constructor(RewardToken _rewardToken) {
        rewardToken = _rewardToken;
    }

    function add(IERC20 _lpToken) public onlyOwner {
        uint256 lastRewardBlock = block.number > startBlock
            ? block.number
            : startBlock;
        totalAllocationPoint = totalAllocationPoint.add(100);
        poolInfos.push(
            PoolInfo({
                lpToken: _lpToken,
                allocationPoint: 100,
                lastRewardBlock: lastRewardBlock,
                accumulastedPerShare: 0
            })
        );
    }

    function deposit(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfos[_pid];
        UserInfo storage user = userInfoMap[_pid][msg.sender];
        updatePool(_pid);

        if (user.amount > 0) {
            uint256 pending = user.amount.mul(
                pool.accumulastedPerShare.div(1e12).sub(user.rewardDebt)
            );
            rewardToken.transfer(msg.sender, pending);
        }

        pool.lpToken.safeTransferFrom(
            address(msg.sender),
            address(this),
            _amount
        );
        user.amount = user.amount.add(_amount);

        user.rewardDebt = user.amount.mul(pool.accumulastedPerShare).div(1e12);
        emit Deposit(msg.sender, _pid, _amount);
    }

    function withdraw(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfos[_pid];
        UserInfo storage user = userInfoMap[_pid][msg.sender];
        require(user.amount >= _amount, "Insufficient user balance!");
        updatePool(_pid);
        uint256 pending = user
            .amount
            .mul(pool.accumulastedPerShare)
            .div(1e12)
            .sub(user.rewardDebt);
        rewardToken.transfer(msg.sender, pending);
        user.amount = user.amount.sub(_amount);
        user.rewardDebt = user.amount.mul(pool.accumulastedPerShare).div(1e12);
        pool.lpToken.safeTransfer(address(msg.sender), _amount);
        emit Withdraw(msg.sender, _pid, _amount);
    }

    function updatePool(uint256 _pid) public {
        PoolInfo storage pool = poolInfos[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = block.number.sub(pool.lastRewardBlock).mul(1e16);
        uint256 reward = multiplier.mul(pool.allocationPoint).div(
            totalAllocationPoint
        );
        rewardToken.mint(address(this), reward);
        pool.accumulastedPerShare = pool.accumulastedPerShare.add(
            reward.mul(1e12).div(lpSupply)
        );
        pool.lastRewardBlock = block.number;
    }
}
