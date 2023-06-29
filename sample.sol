// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; //indicates for version >=0.8.18

contract SimpleStorage {
    //bool, uint(whole no), int(any int), address(Hex), bytes, string
    uint public favnum;

    function store(uint _favnum) public {
        favnum = _favnum;
    }

    //view and pure dont reqd gas fees as view is only used to view
    function retrieve() public view returns(uint){   //returns tell us dtype
        return favnum;
    }
    //if retrieve() is called inside store() function then gas fees will also be applicabale to retrieve
}
//0xd9145CCE52D386f254917e481eB44e9943F39138