pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {

	FundMe fundMe;
	address USER = makeAddr("user");
	uint256 constant SEND_VALUE = 0.1 ether;
	uint256 constant STARTING_BALANCE = 10 ether;

	// this function runs each time, before testing each test function 
	function setUp() external {
		DeployFundMe deployFundMe = new DeployFundMe();
		// fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
		fundMe = deployFundMe.run();
		vm.deal(USER, STARTING_BALANCE);
	}

	function testMinimumDollar() public view {
		assertEq(fundMe.MINIMUM_USD(), 5e18);
	}

	function testFundFailsWithoutEnoughETH() public {
		vm.expectRevert(); // the next line should revert 	
		fundMe.fund(); // send 0 value
	}

	function testFundUpdatesFundDataStructure() public {
		vm.prank(USER); // next tx will be done by user
		fundMe.fund{value: SEND_VALUE}();
	
		uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
		assertEq(amountFunded, SEND_VALUE);
	}

	function testAddFunderToArrayOfFunders() public {
		vm.prank(USER); // next tx will be done by user
		fundMe.fund{value: SEND_VALUE}();

		address funder = fundMe.getFunder(0);
		console.log(funder);
		assertEq(USER, funder);
	}

	// ## Use modifier to make your test more clear and neat. keeping a state tree
	modifier funded () {
		vm.prank(USER);
		fundMe.fund{value: SEND_VALUE}();
		_;
	}

	function testWithdraw () public funded {
		vm.prank(USER); 
		vm.expectRevert();
		fundMe.withdraw();
	}

	//	## Common test format : Arrange, Act, Assert
	function testWithdrawWithASingleUser() public funded {
		// Arrange
		uint256 startingOwnerBalance = fundMe.getOwner().balance;	
		uint256 startingFundMeBalance = address(fundMe).balance;	

		// Act
		vm.prank(fundMe.getOwner());
		fundMe.withdraw();

		// assert
		uint256 endingOwnerBalance = fundMe.getOwner().balance;	
		uint256 endingFundMeBalance = address(fundMe).balance;	
		assertEq(endingFundMeBalance, 0);
		assertEq(
			startingOwnerBalance + startingFundMeBalance,
			endingOwnerBalance
		);
	}

	function testWithdrawWithAMultipleUsers() public funded {
		// Arrange
		uint160 numberOfFunder = 10;
		uint160 startingFunderIndex = 1;
		for (uint160 i = startingFunderIndex; i<numberOfFunder; i++) {
			// hoax does vm.prank and vm.deal
			hoax(address(i), SEND_VALUE);
			fundMe.fund{value: SEND_VALUE}();
		}
		uint256 startingOwnerBalance = fundMe.getOwner().balance;	
		uint256 startingFundMeBalance = address(fundMe).balance;	

		// Act
		vm.startPrank(fundMe.getOwner());
		fundMe.withdraw();
		vm.stopPrank();
	
		// assert
		uint256 endingOwnerBalance = fundMe.getOwner().balance;	
		uint256 endingFundMeBalance = address(fundMe).balance;	
		assertEq(endingFundMeBalance, 0);
		assertEq(
			startingOwnerBalance + startingFundMeBalance,
			endingOwnerBalance
		);
	}
}
