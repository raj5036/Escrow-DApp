import { getAddress, parseEther } from 'viem';
import { expect } from "chai";
import hre from "hardhat";
import { loadFixture } from '@nomicfoundation/hardhat-toolbox-viem/network-helpers';

describe("Escrow", () => {
	const deployEscrowFixture = async () => {
		// Contracts are deployed using the first signer/account by default
		const [ owner ] = await hre.viem.getWalletClients();

		const escrow = await hre.viem.deployContract("Escrow", [], {
			value: parseEther("10"),
		});

		const publicClient = await hre.viem.getPublicClient();

		return {
			escrow,
			owner,
			publicClient,
		};
	}

	describe("Deployment", () => {
		it("Should set the right arbiter", async () => {
			const { escrow, owner } = await loadFixture(deployEscrowFixture);

			expect(await escrow.read.arbiter()).to.equal(getAddress(owner.account.address));
		});
	});
})