// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyPunks is ERC721 {
    address public owner;
    uint256 public counter;

    mapping(address => bool) public isWhitelisted;
    mapping(address => uint256) public userTokenId;

    event NewWhitelistAdded(address user);
    event NewPunkMinted(address user, uint256 tokenId);
    event PunkBurned(address user, uint256 tokenId);

    constructor() ERC721("MyPunks", "PUNK") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner!");
        _;
    }

    modifier onlyWhitelisted() {
        require(isWhitelisted[msg.sender] == true, "Not whitelisted!");
        _;
    }

    function addWhitelist(address _user) external onlyOwner {
        isWhitelisted[_user] = true;

        emit NewWhitelistAdded(_user);
    }

    function mint() external onlyWhitelisted {
        require(userTokenId[msg.sender] == 0, "Already minted!");

        uint256 tokenId = ++counter;

        _safeMint(msg.sender, tokenId);

        userTokenId[msg.sender] = tokenId;

        emit NewPunkMinted(msg.sender, tokenId);
    }

    function burn(address _user) external onlyOwner {
        uint256 tokenId = userTokenId[_user];

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
