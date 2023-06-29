// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract Lottery{

    address public manager;

    address payable[] public participants;
    constructor() {
        manager = msg.sender;
    }

    receive() external payable{
        require(msg.value == 1 ether,"Transfer 1 ETH");
        participants.push(payable(msg.sender));
    }

    function getBalance() onlyManager public view returns(uint) {
        return address(this).balance;
    }

    function random() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao ,block.timestamp,participants.length)));
    }

    function selectWinner() onlyManager public{
        require(participants.length >= 3);
        uint r = random();
        uint index = r % participants.length;
        participants[index].transfer(getBalance());
        participants = new address payable[](0);
    }

    modifier onlyManager{
        require(msg.sender == manager,"Only manager can view");
        _;
    }
}