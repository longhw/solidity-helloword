// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

contract Uint8OverFlow {
    uint8 public a = 255;

    function increment() public {
        a = a + 1;
    }
}