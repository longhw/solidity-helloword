// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MergeSortedArray {
    function merge(
        uint[] calldata arry1,
        uint[] calldata arry2
    ) public pure returns (uint[] memory) {
        uint i = arry1.length;
        uint j = arry2.length;
        uint k = arry1.length + arry2.length;
        uint[] memory returnArry = new uint[](k);

        while (i > 0 && j > 0) {
            if (arry1[i - 1] > arry2[j - 1]) {
                returnArry[k - 1] = arry1[i - 1];
                i--;
            } else {
                returnArry[k - 1] = arry2[j - 1];
                j--;
            }
            k--;
        }

        while (i > 0) {
            returnArry[k - 1] = arry1[i - 1];
            i--;
            k--;
        }

        while (j > 0) {
            returnArry[k - 1] = arry2[j - 1];
            j--;
            k--;
        }

        return returnArry;
    }
}
