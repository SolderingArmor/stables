// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {TestERC20} from "../src/test/TestERC20.sol";
import {Pool} from "../src/Pool.sol";

contract PoolTest is Test {
    Pool pool;

    uint256 constant MAX_INT = ~uint256(0);

    uint256 internal alicePk = 0xa11ce;
    uint256 internal bobPk = 0xb0b;
    uint256 internal calPk = 0xca1;

    address payable internal alice = payable(vm.addr(alicePk));
    address payable internal bob = payable(vm.addr(bobPk));
    address payable internal cal = payable(vm.addr(calPk));

    TestERC20 internal DAI;
    TestERC20 internal USDC;
    TestERC20 internal USDT;

    TestERC20[] erc20s;

    function _setApprovals(address _owner) internal virtual {
        vm.startPrank(_owner);
        for (uint256 i = 0; i < erc20s.length; ++i) {
            erc20s[i].approve(address(pool), MAX_INT);
        }

        vm.stopPrank();
    }

    /**
     * @dev Deploy test token contracts
     */
    function _deployTestTokenContracts() internal {
        pool = new Pool();
        DAI = new TestERC20();
        USDC = new TestERC20();
        USDT = new TestERC20();

        vm.label(address(DAI), "DAI");

        emit log("Deployed test token contracts");
    }

    /**
     * @dev Allocate amount of each token to _to
     */
    function allocateTokensAndApprovals(address _to, uint128 _amount) internal {
        vm.deal(_to, _amount);
        for (uint256 i = 0; i < erc20s.length; ++i) {
            erc20s[i].mint(_to, _amount);
        }
        emit log_named_address("Allocated tokens to", _to);
        _setApprovals(_to);
    }

    function setUp() public {
        vm.label(alice, "alice");
        vm.label(bob, "bob");
        vm.label(cal, "cal");
        vm.label(address(this), "testContract");

        _deployTestTokenContracts();
        erc20s = [DAI, USDC, USDT];

        _setApprovals(alice);
    }

    function testSwap() public {
        uint256 liq = 1000e18;
        DAI.mint(address(pool), liq);
        USDC.mint(address(pool), liq);

        uint256 amount = 100e18;
        DAI.mint(alice, amount);

        assertEq(DAI.balanceOf(alice), amount);
        assertEq(USDC.balanceOf(alice), 0);

        assertEq(DAI.balanceOf(address(pool)), liq);
        assertEq(USDC.balanceOf(address(pool)), liq);

        vm.prank(alice);
        pool.swap(IERC20(address(DAI)), amount, IERC20(address(USDC)));

        assertEq(DAI.balanceOf(address(pool)), liq + amount);
        assertEq(USDC.balanceOf(address(pool)), liq - amount);

        assertEq(DAI.balanceOf(alice), 0);
        assertEq(USDC.balanceOf(alice), amount);
    }
}
