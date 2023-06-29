// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <=0.9.0;

contract SimpleStorage{

    uint favnum;

    struct People{
        uint num;
        string name;
    }

    People[] public a;

    mapping (string => uint) public mp;

    function store(uint fno) public virtual{
        favnum = fno;
    }

    function retrieve() view public returns(uint){
        return favnum;
    }

    //EVM can access and store info in calldata,memory,storage,stack,code,logs
    function addPerson(string memory nm, uint fno) public{
        a.push(People( fno, nm));
        //alternative for struct-array
        //People memory newPerson = People({num:fno, name:nm});
        //a.push(newPerson);

        mp[nm]=fno;
        //name is mapped with its favnum
    }
}