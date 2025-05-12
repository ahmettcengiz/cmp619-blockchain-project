// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public creator;
    uint public goal;
    uint public deadline;
    uint public totalRaised;

    mapping(address => uint) public contributions;

    constructor(uint _goalInWei, uint _durationInMinutes) {
        creator = msg.sender;
        goal = _goalInWei;
        deadline = block.timestamp + (_durationInMinutes * 1 minutes);
    }

    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign has ended");
        require(msg.value > 0, "Must send ETH");

        contributions[msg.sender] += msg.value;
        totalRaised += msg.value;
    }

    function withdraw() external {
        require(msg.sender == creator, "Only campaign creator can withdraw");
        require(block.timestamp >= deadline, "Campaign not finished");
        require(totalRaised >= goal, "Funding goal not met");

        payable(creator).transfer(address(this).balance);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }
}
