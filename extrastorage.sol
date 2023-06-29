// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./simplestorage.sol";

contract ExtraStorage is SimpleStorage {
    
    //override
    //write "virtual" in store fxn in simplestorage.sol, write "override" in store fxn in extrastorage.sol
    function store(uint favno) public override{
        favnum = favno +5;
    }
}