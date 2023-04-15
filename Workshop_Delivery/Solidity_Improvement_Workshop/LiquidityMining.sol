// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract LiquidityMining is Ownable {
    IERC20 public rewardToken;
    IUniswapV2Pair public lpToken;
    uint256 public rewardRate;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userStakedAmount;
    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public userRewards;

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(
        address _rewardToken,
        address _lpToken,
        uint256 _rewardRate
    ) {
        rewardToken = IERC20(_rewardToken);
        lpToken = IUniswapV2Pair(_lpToken);
        rewardRate = _rewardRate;
        lastUpdateTime = block.timestamp;
    }

    function rewardPerToken() public view returns (uint256) {
        if (lpToken.balanceOf(address(this)) == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored +
            ((block.timestamp - lastUpdateTime) * rewardRate * 1e18) / lpToken.balanceOf(address(this));
    }

    function earned(address account) public view returns (uint256) {
        return
            (userStakedAmount[account] * (rewardPerToken() - userRewardPerTokenPaid[account])) / 1e18 +
            userRewards[account];
    }

    function stake(uint256 amount) public {
        require(amount > 0, "Cannot stake 0");
        updateReward(msg.sender);
        lpToken.transferFrom(msg.sender, address(this), amount);
        userStakedAmount[msg.sender] += amount;
        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Cannot withdraw 0");
        updateReward(msg.sender);
        userStakedAmount[msg.sender] -= amount;
        lpToken.transfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);

    }

        function getReward() public {
        updateReward(msg.sender);
        uint256 reward = userRewards[msg.sender];
        if (reward > 0) {
            userRewards[msg.sender] = 0;
            rewardToken.transfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    function updateReward(address account) internal {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = block.timestamp;
        if (account != address(0)) {
            userRewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
    }
}