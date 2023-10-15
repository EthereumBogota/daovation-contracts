// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/token/ERC721/ERC721.sol";
import "@openzeppelin/access/Ownable.sol";
import "@openzeppelin/utils/Counters.sol";

contract AppNFT is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string baseURI;

    constructor(string memory _name, string memory _symbol, string memory _URI)
        ERC721(_name, _symbol)
    {
        baseURI = _URI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        _requireMinted(tokenId);

        return baseURI;
    }

    function safeMint(address to) external onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function approve(address, uint256) public pure override {
        revert("Approve isn't allowed");
    }

    function setApprovalForAll(address, bool) public pure override {
        revert("setApprovalForAll isn't allowed");
    }

    function transferFrom(address, address, uint256) public pure override {
        revert("transferFrom isn't allowed");
    }

    function safeTransferFrom(address, address, uint256, bytes memory)
        public
        pure
        override
    {
        revert("safeTransferFrom isn't allowed");
    }
}
