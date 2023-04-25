pragma solidity ^0.6.0;
import "./interface.sol";
import "./SushiToken.sol";

contract MasterChef {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // Info of each user.
    struct UserInfo {
        uint256 amount;     // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
    }

    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken;           // Address of LP token contract.
        uint256 allocPoint;       // How many allocation points assigned to this pool. SUSHIs to distribute per block.
        uint256 lastRewardBlock;  // Last block number that SUSHIs distribution occurs.
        uint256 accSushiPerShare; // Accumulated SUSHIs per share, times 1e12. See below.
    }

    // The SUSHI TOKEN!
    SushiToken public sushi;

    // SUSHI tokens created per block.
    // 设置每个区块的sushi数量为1000
    // uint256 public sushiPerBlock;

    // Info of each pool.
    PoolInfo[] public poolInfo;

    // Info of each user that stakes LP tokens.
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;

    // Total allocation poitns. Must be the sum of all allocation points in all pools.
    // 总共分配的点数
    uint256 public totalAllocPoint = 0;

    // // The block number when SUSHI mining starts.
    // 开始区块
    uint256 public startBlock = 0;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);

    constructor(
        SushiToken _sushi
    ) public {
        sushi = _sushi;
    }

    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }

    // Add a new lp to the pool. Can only be called by the owner.
    // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
    // 添加质押池
    // 添加一个质押池，增加100哥分配点位
    function add(IERC20 _lpToken) public {
        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        totalAllocPoint = totalAllocPoint.add(100);
        poolInfo.push(PoolInfo({
            lpToken: _lpToken,
            // 这个质押池的分配点位
            allocPoint: 100,
            // 上一个更新奖励的区块
            lastRewardBlock: lastRewardBlock,
            // 质押一个lp token的全局收益
            // 用户在质押LPToken的时候，会把当前accSushiPerShare记下来作为起始点位，当解除质押的时候，可以通过最新的accSushiPerShare减去起始点位，就可以得到用户实际的收益。
            accSushiPerShare: 0
        }));
    }

    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to) private pure returns (uint256) {
            return _to.sub(_from);
    }

    // Update reward variables of the given pool to be up-to-date.
    // 更新 Pool 的sushi奖励
    function updatePool(uint256 _pid)  private{
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        // 获取质押池中的lp token
        uint256 lpSupply = pool.lpToken.balanceOf(address(this));
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        // 获取乘数
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        // sushiReward = 区块乘数 * 每个区块能够获取的sushi * pool的分配点位 / 总分配点位
        uint256 sushiReward = multiplier.mul(1000).mul(pool.allocPoint).div(totalAllocPoint);
        // mint 出对应的sushi奖励
        sushi.mint(address(this), sushiReward);
        // 更新池子的 accSushiPerShare
        pool.accSushiPerShare = pool.accSushiPerShare.add(sushiReward.mul(1e12).div(lpSupply));
        pool.lastRewardBlock = block.number;
    }

    // Deposit LP tokens to MasterChef for SUSHI allocation.
    function deposit(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        // 追加质押，先结算之前的奖励
        if (user.amount > 0) {
            uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
            sushi.transfer(msg.sender, pending);
        }
        // 把用户的lp token转移到 MasterChef 合约中
        pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
        user.amount = user.amount.add(_amount);
        // 更新不可领取部分
        user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
        emit Deposit(msg.sender, _pid, _amount);
    }

    // Withdraw LP tokens from MasterChef.
    function withdraw(uint256 _pid, uint256 _amount) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid);
        uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
        sushi.transfer(msg.sender,pending);
        user.amount = user.amount.sub(_amount);
        user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);
        pool.lpToken.safeTransfer(address(msg.sender), _amount);
        emit Withdraw(msg.sender, _pid, _amount);
    }
}