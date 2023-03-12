// Contrato Marcella Zorzo 
// contrato Marcella NFT 0x3aC8499A3297EA86d1933Ab4AbE776EdC33f6A61 
// Contrato responsável por mintar as frações 0xe75a9a9f46F1d737d4567025e965a13cD304fce6
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import  "@openzeppelin/contracts/access/Ownable.sol";

contract MarcellaZorzo is Ownable, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;

    constructor(string memory _name, string memory _symbol) 
    ERC721(_name, _symbol) {}

    function mint(string memory tokenURI) 
        public onlyOwner 
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }
}

