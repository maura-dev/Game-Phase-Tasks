// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

 import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
  bool openToWithdraw = false;

  uint startTime;

  uint256 public deadline;

  ExampleExternalContract public exampleExternalContract;

  constructor(address payable exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
      startTime= block.timestamp;
       deadline = startTime + 72 hours;
  //sets deadline to 30 seconds after contract deployment

  }

  mapping ( address => uint256 ) public balances;
  //tracks all stakes from stakers

  uint256 public constant threshold = 1 ether;
  //tracks threshold

  modifier deadlineReached(){
    require(deadline <= block.timestamp, "Deadline has not elapsed");
    _;
  }

  modifier notCompleted(){
    require(!exampleExternalContract.completed() , "This transaction has been completed");
    _;
  }

  modifier belowThreshold(){
    require( openToWithdraw == true, "Balance above threshold");
    _;
  }

  event Stake(address,uint256);
  event Withdraw(address, uint256);
  event Transfer ( ExampleExternalContract, uint256);

  function stake() public payable{
    if(getUserStake() ==0){
         balances[msg.sender] = msg.value;
    } else {
      balances[msg.sender] = msg.value + getUserStake();
    }
     
      emit Stake(msg.sender, msg.value);
  }

  function withdraw() public deadlineReached notCompleted belowThreshold{
      uint amount = getUserStake();
      if(openToWithdraw){
          payable(msg.sender).transfer(amount);
          emit Withdraw(msg.sender, amount);
      } else{
        return;
      }
  }

  function getUserStake() public  view returns (uint256){
    return balances[msg.sender];
  }

  function execute() public  deadlineReached notCompleted{
          if(address(this).balance >= threshold){
          exampleExternalContract.complete{value: address(this).balance}();
          emit Transfer(exampleExternalContract, address(this).balance);
        } else{
          openToWithdraw = true;
        }
        
  }

  function timeLeft() public view returns (uint256){
    if (block.timestamp >= deadline){
      return 0;
    } else{
      return deadline - block.timestamp;    
    }   
  }

  receive() external payable{
    if(msg.value > 0){
        stake();
    }
    
  }

function contractBalance() public view returns (uint amount){
  amount = address(this). balance;
  return amount;
}

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )


  // After some `deadline` allow anyone to call an `execute()` function
  //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value


  // if the `threshold` was not met, allow everyone to call a `withdraw()` function


  // Add a `withdraw()` function to let users withdraw their balance


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


  // Add the `receive()` special function that receives eth and calls stake()


}
