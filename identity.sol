// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;

contract Identity{
    string name;
    uint age;

    constructor()
    {
        name="Janam";
        age=20;
    }

    struct Student{
        string s_name;
        uint s_age;
    }

    mapping (uint => Student) public data;

    function getname() view public returns(string memory) {
        return name;
    }

    function getage() view public returns(uint) {
        return age;
    }

    function setage() public{
        age=age+1;
    }
    //this is how a struct mapping is used
    function setter(uint _roll,string memory _name,uint _age) public{
        data[_roll] = Student(_name, _age);
    }
}