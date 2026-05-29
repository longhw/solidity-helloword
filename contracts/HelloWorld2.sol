// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWorld2 {
    
    string public message = "Hello Solidity!";

    address public immutable owner;// 创建者

    constructor() {
        owner = msg.sender;
    }

    function updateMessage(string calldata newMessage) public {
        message = newMessage;
    }

    function getMessage() public view returns (string memory) {
        return message;
    }

    function getOwner() public view returns (address) {
        return owner;
    }
    
}