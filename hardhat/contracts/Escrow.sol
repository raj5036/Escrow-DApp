/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Escrow {
	address private arbiter;
	mapping(address => bool) public depostors;

	error NotArbiter(address);
	error InsufficientFunds();

	event TransactionApproved(address indexed from, address indexed to, uint256 amount);
	event DepositorAdded(address indexed depositor);
	event FundsSent(address indexed beneficiary, uint256 amount);

	constructor	() payable {
		arbiter = msg.sender; // Initially the deployer is the arbiter
	}

	receive() external payable {}

	modifier OnlyArbiter() {
		if (msg.sender != arbiter) {
			revert NotArbiter(msg.sender);
		}
		_;
	}

	modifier OnlyDepositor () {
		require(depostors[msg.sender], "You are not a depositor");
		_;
	}

	function transferArbiterRole(address _addr) public OnlyArbiter {
		arbiter = _addr;
	}

	function getCurrentFundsAmount() public view OnlyArbiter returns (uint256) {
		return address(this).balance;
	}

	function addDepositor(address depositor) external {
		depostors[depositor] = true;
		emit DepositorAdded(depositor);
	}

	function sendFundsToBeneficiary(address beneficiary, uint256 amount) external OnlyDepositor {
		if (address(this).balance < amount) {
			revert InsufficientFunds();
		}
		
		(bool success, ) = beneficiary.call{value: amount}("");
		require(success, "Failed to send funds to beneficiary");

		emit FundsSent(beneficiary, amount);
	}
}