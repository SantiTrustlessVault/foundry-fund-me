// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {FundMe} from "../src/FundMe.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test{

    FundMe fundMe;
    address USER = makeAddr("User");
    uint256 constant SEND_VALUE = 1 ether;


function setUp() external {
    DeployFundMe deployFundMe = new DeployFundMe();
    fundMe = deployFundMe.run();
    vm.deal(USER, 10 ether);
}

function testMinimumUsdIsFive() external view{
    // This test checks that the minimum USD value is Set to 5 usd
    assertEq(fundMe.MINIMUM_USD(), 5e18);
}

function testOwnerIsMsgSender() external view{
    console.log("Owner address: ", fundMe.getOwner());
    console.log("msg sender: " ,msg.sender);
    console.log("This test contract address: ", address(this));
    
// yo despliego -> FundMeTest -> despliega -> fundMe;
// entonces el dueño del contrato FundMe es el address de FundMeTest
    assertEq(fundMe.getOwner(), msg.sender);
}

function testPriceFeedVersionAccurate() external view{
    uint256 version = fundMe.getVersion();
    assertEq(version, 4); // Mainnet Version is 6, Sepolia Version is 4
}
function testFundFailsWithoutEnoughEth() external {
    vm.expectRevert();
    // assert(this tx fails/reverts) // 1 ETH
    fundMe.fund();
}

function testFundUpdatesFundedDataEstructure() external{
    vm.prank(USER);
    fundMe.fund {value: SEND_VALUE}();
    // check if array of funders is updated
    uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
    assertEq(amountFunded, SEND_VALUE);
}

function testFundersListIsUpdated() public  {
    vm.prank(USER);
    fundMe.fund {value: SEND_VALUE}();
    address funder = fundMe.getFunderFromFunders(0);
    assertEq(funder, USER);
}

modifier funded(){
    vm.prank(USER);
    fundMe.fund{value: SEND_VALUE}();
    _;
}

function testOnlyOwnerCanWithdraw() public funded {
    vm.expectRevert();
    vm.prank(USER);
    fundMe.withdraw();
}

function testOwnerWithdrawsFunds() public funded {
  //Arrange
    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;


  //Act
    vm.prank(fundMe.getOwner());
    fundMe.withdraw();
  //Assert
    uint256 endingOwnerBalance = fundMe.getOwner().balance;
    uint256 endingFundMeBalance = address(fundMe).balance;

    assertEq(endingFundMeBalance, 0);
    assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
}

function testWithdrawWithMultipleFundersCheaper() public funded {
    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;

    for(uint160 i = startingFunderIndex; i < numberOfFunders; i++){
        hoax(address(i), SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}();
    }

    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;

    // act
    vm.prank(fundMe.getOwner());
    fundMe.cheaperWithdraw();
    
    // assert
    assert(address(fundMe).balance == 0);
    assertEq(startingOwnerBalance + startingFundMeBalance, fundMe.getOwner().balance);
    

}




function testWithdrawWithMultipleFunders() public funded{
    uint160 numberOfFunders = 10;
    uint160 startingFunderIndex = 1;
    
    for(uint160 i = startingFunderIndex; i < numberOfFunders; i++){
    
    hoax(address(i), SEND_VALUE);
    fundMe.fund{value: SEND_VALUE}();
    }

    uint256 startingOwnerBalance = fundMe.getOwner().balance;
    uint256 startingFundMeBalance = address(fundMe).balance;

    // act
    vm.startPrank(fundMe.getOwner());
    fundMe.withdraw();
    vm.stopPrank();
    // assert
    assert(address(fundMe).balance == 0);
    assertEq(startingOwnerBalance + startingFundMeBalance, fundMe.getOwner().balance);
}


}


