// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Holder.sol";


contract MyToken is ERC20,ERC721Holder, Ownable {
     IERC721 public nft;
     mapping(uint256 => address) public tokenOwnwerOf;
     mapping(uint256 => uint256) public tokenStakedAt;
     uint256 public EMISSION_RATE = 50 * 10 ^ decimals()) / 1 days;


    constructor(address _nft) ERC20("MyToken", "MTK") {
        nft =IERC721(_nft);
    }

    // function mint(address to, uint256 amount) public onlyOwner {
    //     _mint(to, amount);
    // }

    function stake(uint256 tokenId) external{
        nft.safeTransferFrom(msg.sender,address(this),token);
        tokenOwnwerOf[tokenId] = msg.sender;
        tokenStakedAt[tokenId] = block.timestamp;
    }

    function calculateTokens(uint256 tokenId) public view returns(uint256){
        uint256 timeElapsed = block.timestamp - tokenStakedAt[tokenId];
        return timeElapsed * EMISSION_RATE;
    }

    function unstake (uint256 tokenId)external{
        require(tokenOwnwerOf[tokenId] == msg.sender,"You can't unstake ");
        _mint(msg.sender, calculateTokens(tokenId)); //minting the tokens for staking
        nft.transferFrom(address(this),msg.sender,tokenId);
        delete tokenOwnwerOf[tokenId];
        delete tokenStakedAt[tokenId];


    }
}