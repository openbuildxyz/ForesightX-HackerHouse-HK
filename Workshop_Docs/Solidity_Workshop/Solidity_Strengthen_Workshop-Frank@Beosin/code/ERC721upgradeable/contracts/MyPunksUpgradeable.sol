pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract MyPunksUpgradeable is Initializable, ERC721Upgradeable{

    address public owner;
    uint256 public counter;

    mapping(address => bool) public isWhitelisted;
    mapping(address => uint256) public userTokenId;

    event NewWhitelistAdded(address user);
    event NewPunkMinted(address user, uint256 tokenId);
    event PunkBurned(address user, uint256 tokenId);


    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner!");
        _;
    }

    modifier onlyWhitelisted() {
        require(isWhitelisted[msg.sender] == true, "Not whitelisted!");
        _;
    }

    // Locks the contract, preventing any future reinitialization.
    // @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC721_init("MyPunks", "PUNK");
        owner =  msg.sender;
    }

    function addWhitelist(address _user) external onlyOwner {
        isWhitelisted[_user] = true;

        emit NewWhitelistAdded(_user);
    }

    function mint() external  {
        require(userTokenId[msg.sender] == 0, "Already minted!");

        uint256 tokenId = ++counters;

        _safeMint(msg.sender, tokenId);

        userTokenId[msg.sender] = tokenId;

        emit NewPunkMinted(msg.sender, tokenId);
    }

    function burn() external onlyOwner {
        uint256 tokenId = userTokenId[msg.sender];

        _burn(tokenId);

        emit PunkBurned(_user, tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal pure override {
        require(from == address(0) || to == address (0),
        "Transfer not allowed!");
    }


}

