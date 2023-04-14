// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TheEdenNFT is ERC721, ERC721Burnable, AccessControl {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    

    event AdminRoleChanged(
        address indexed from,
        address indexed to
    );

    constructor(address admin) ERC721("TheEdenNFT", "EDEN")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
    }

    modifier onlyAdmin()
    {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Restricted to admin role");
        _;
    }

    modifier onlyMinter()
    {
        require(hasRole(MINTER_ROLE, msg.sender), "Restricted to minter role");
        _;
    }

    function transferAdminRole(address to)
        public
        onlyAdmin
    {
        _grantRole(DEFAULT_ADMIN_ROLE, to);
        require(hasRole(DEFAULT_ADMIN_ROLE, to), "Grant admin role failed, stop revoke origin admin role!");
        _revokeRole(DEFAULT_ADMIN_ROLE, msg.sender);
        emit AdminRoleChanged(msg.sender, to);
    }

    function grantMinterRole(address minter)
        public
        onlyAdmin
    {
        _grantRole(MINTER_ROLE, minter);
    }


    function mint(address to)
        public
        payable
        onlyMinter
        returns(uint256)
    {
        require(msg.value >= 1000, "Not enough TOKEN sent; check price!");
        uint256 newItemId = _tokenIds.current();
        _mint(to, newItemId);
        _tokenIds.increment();
        return newItemId;
    }

    function burn (uint256 tokenId)
         public
         override(ERC721Burnable)
    {
        // admin can burn all NFT
        require(_isApprovedOrOwner(_msgSender(), tokenId) || hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "ERC721: caller is not token owner or approved, neither admin");
        _burn(tokenId);
    }

    function grantMinterRoleList(address[] memory minterlist) public onlyAdmin {
        for(uint i = 0;i < minterlist.length;++i) {
            _grantRole(MINTER_ROLE, minterlist[i]);
        }
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
