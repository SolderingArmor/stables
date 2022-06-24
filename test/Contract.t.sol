// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract ContractTest is Test {
    uint256 foobar;

    function setUp() public {
        foobar = 42;
    }

    function testFoobarSecond() public {
        assertEq(foobar, 42);
    }

    function testFoobar() public {
        assertEq(foobar, 42);
    }

    function testExample() public {
        assertTrue(true);
    }

    function testFuz(uint8 amount) external {
        assertEq(amount, amount);
    }
}
