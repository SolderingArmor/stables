// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Pool {
    function swap(
        IERC20 _from,
        uint256 _amount,
        IERC20 _to
    ) external {
        _from.transferFrom(msg.sender, address(this), _amount);
        _to.transfer(msg.sender, _amount);
    }
}
