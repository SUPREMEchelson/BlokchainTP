// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract JeuneDiplomeToken is ERC20, Ownable {
    uint256 public constant tokensPerEther = 100; // The token price: 1 ETH = 100 tokens
    uint256 public rewardAmount; // Amount of tokens as reward, will be set in constructor
    uint256 public verificationFee; // Verification fee in tokens, will be set in constructor


    constructor() ERC20("JeuneDiplomeToken", "JDT") Ownable(msg.sender) {
        rewardAmount = 15 * (10 ** decimals());
        verificationFee = 10 * (10 ** decimals());
        _mint(msg.sender, 1000000 * (10 ** decimals()));
    }

    // Function to allow users to buy tokens by sending ETH
    function buyTokens() external payable {
        require(msg.value > 0, "Vous devez envoyer de l'Ether");
        uint256 amountToBuy = msg.value * tokensPerEther; // Calculate the number of tokens to give
        _transfer(owner(), msg.sender, amountToBuy); // Transfer tokens to the user
    }

    // Function to reward companies, only owner can call
    function rewardCompany(address recruitmentAgent) public onlyOwner {
        _transfer(owner(), recruitmentAgent, rewardAmount); // Transfer reward tokens to the recruitment agent
    }

    // Function to charge users for verification, only owner can call
    function chargeForVerification(address user) public onlyOwner {
        require(balanceOf(user) >= verificationFee, "L'utilisateur n'a pas assez de tokens");
        _transfer(user, owner(), verificationFee); // Transfer verification fee to the owner
    }

    // Owner can withdraw ETH from the contract
    function withdrawEther() external onlyOwner {
        payable(owner()).transfer(address(this).balance); // Transfer ETH to the owner
    }

    // Special function to receive ETH and automatically trigger token purchase
    receive() external payable {
        require(msg.value > 0, "Vous devez envoyer de l'Ether");
        uint256 amountToBuy = msg.value * tokensPerEther; // Calculate the number of tokens to give
        _transfer(owner(), msg.sender, amountToBuy); // Transfer tokens to the user
    }
}
