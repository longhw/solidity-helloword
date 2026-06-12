// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BeggingContract {

    mapping(address => uint) public donatorAmount;
    address public owner;
    uint public expiredTime;

    event donation(address indexed donator, uint amount);
    event withdrawal(address indexed withdrawer, uint amount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call this function");
        _;
    }

    bool private lock;
    modifier noReentrancy() {
        require(!lock, "Reentrancy detected");
        lock = true;
        _;
        lock = false;
    }

    constructor(uint _durationDays) {
        owner = msg.sender;
        expiredTime = block.timestamp + (_durationDays * 1 days);
    }

    function donate() external payable {
        require(msg.sender != address(0), "donator can not be zero address");
        require(msg.value > 0, "donation amount must be greater than zero");
        require(block.timestamp < expiredTime, "donation period has expired");
        
        donatorAmount[msg.sender] = msg.value;

        emit donation(msg.sender, msg.value);
    }

    function withdraw() external onlyOwner noReentrancy {
        require(address(this).balance > 0, "Insufficient balance");
        payable(msg.sender).transfer(address(this).balance);
        
        emit withdrawal(msg.sender, address(this).balance);
    }

    function getDonation(address donator) external view returns (uint) {
        require(donator != address(0), "donator can not be zero address");
        return donatorAmount[donator];
    }

}