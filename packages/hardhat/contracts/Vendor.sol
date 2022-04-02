pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  uint256 public constant tokensPerEth = 100;

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable{
    uint amount = msg.value;
    require(amount > 0, "Send ETH to buy some tokens");
    uint tokenAmount = amount * tokensPerEth; //token equivalent
    
  //check if vendor has enough tokens
  uint256 vendorBalance = yourToken.balanceOf(address(this));
  require(vendorBalance >= tokenAmount, "Vendor doesn't have enough tokens");
  
  //transfer tokens
  bool success = yourToken.transfer(msg.sender, tokenAmount);
  require(success, "Failed to transfer tokens");

  emit BuyTokens(msg.sender, msg.value, tokenAmount);

  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH

  function withdraw() public onlyOwner{
    require(address(this).balance > 0 , " You do not have any ETH to withdraw");
    (bool success,) = msg.sender.call{value: address(this).balance}("");
    require(success, "Failed to withdraw ETH");
  }

  // ToDo: create a sellTokens() function:

  function sellTokens(uint tokenAmountToSell) public {
    //check that amount of tokens to sell is more than 0
    require( tokenAmountToSell > 0, "Amount should be more than 0");

    //check that the token balance of user is enough to sell 
    uint256 userBalance = yourToken.balanceOf(msg.sender);
    require(userBalance >= tokenAmountToSell, "Your balance is too low");

    //check that the vendor balance is enough to pay for the tokens
    uint256 amountOfEthToTransfer = tokenAmountToSell/ tokensPerEth;
    uint256 ownerEthBal = address(this).balance;
    require( ownerEthBal >= amountOfEthToTransfer, "Vendor balance is too low to purchase");

    bool success = yourToken.transferFrom(msg.sender, address(this), tokenAmountToSell);
    require(success, "Failed to transfer tokens");

    (success,) = msg.sender.call{value: amountOfEthToTransfer}("");
    require(success, "Failed to send ETH");
  }

}