// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

contract Voting {

    mapping(address => uint) public votes;
    address[] public candidates;
    address public owner;

    event voting(address indexed voter, address indexed candidate, uint);

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function vote(address _candidate) external {
        require(_candidate != address(0), "Candidate address cannot be zero");
        if(votes[_candidate] == 0) {
            candidates.push(_candidate);
        }
        votes[_candidate] += 1;
        emit voting(msg.sender, _candidate, 1);
    }

    function getVotes(address _candidate) external view returns (uint) {
        require(_candidate != address(0), "Candidate address cannot be zero");
        return votes[_candidate];
    }

    function resetVotes() external onlyOwner {
        address[] memory temCandidates = candidates;
        for(uint i = 0; i < temCandidates.length; i++) {
            delete votes[temCandidates[i]];
        }
        delete candidates;
    }

}