/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Escrow {
	address private arbiter;

	error NotArbiter(address);

	constructor	() payable {
		arbiter = msg.sender; // Initially the deployer is the arbiter
	}

	modifier OnlyArbiter() {
		if (msg.sender != arbiter) {
			revert NotArbiter(msg.sender);
		}
		_;
	}

	function transferArbiterRole(address _addr) public OnlyArbiter {
		arbiter = _addr;
	}

	function getCurrentFundsAmount() public view OnlyArbiter returns (uint256) {
		return address(this).balance;
	}
}