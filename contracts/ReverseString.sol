// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract ReverseString {
    function reverse(string calldata str) public pure returns (string memory) {
        bytes calldata strBytes = bytes(str);
        uint256 length = strBytes.length;
        bytes memory reversedBytes = new bytes(length);

        for (uint256 i = 0; i < length; i++) {
            reversedBytes[i] = strBytes[length - 1 - i];
        }

        return string(reversedBytes);
    }
}