// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Task2 {
    uint[] public data;

    // 这个函数有很多优化空间
    function processData(uint[] calldata input) external  {
        uint len = input.length;
        data = new uint[](len);
        for(uint i = 0; i < len; i++) {
           data[i] = input[i] * 2;
        }
    }

    // 这个函数也可以优化
    function getSum() external view returns (uint sum) {
        uint len = data.length;
        uint[] memory cachedData = data;
        for(uint i = 0; i < len; i++) {
            sum += cachedData[i];
        }
    }
    
}