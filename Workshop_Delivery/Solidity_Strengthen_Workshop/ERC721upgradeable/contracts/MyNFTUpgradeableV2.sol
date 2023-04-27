pragma solidity ^0.8.18;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract MyNFTUpgradeableV2 is ERC721Upgradeable {
    mapping(address => bool) public isWhitelist;
    mapping(address => bool) public minted;

    address public owner;
    uint256 public totalSupply;

    modifier onlyOwner() {
        require(msg.sender == owner, "only Owner");
        _;
    }

    modifier onlyWhitelist() {
        require(isWhitelist[msg.sender] == true, "only whitelist");
        _;
    }

    modifier onlyNotMint() {
        require(!minted[msg.sender], "Already Minted");
        _;
    }

    function version() external pure returns(uint256 version) {
        return 2;
    }

    function initialize() initializer public {
        __ERC721_init("MyNFT", "MyNFT");
        owner =  msg.sender;
    }

    function addWhitelist(address _user) external onlyOwner {
        isWhitelist[_user] = true;
    }

    function mint() external onlyWhitelist {
        uint256 tokenId = totalSupply;
        _safeMint(msg.sender, tokenId);
        minted[msg.sender] = true;
        totalSupply++;
    }

}

