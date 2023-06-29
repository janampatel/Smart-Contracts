// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./simplestorage.sol";

contract StorageFactory {

    SimpleStorage[] public simplestoragearray;

    function createSimpleStorageContract() public {
        SimpleStorage simplestorage = new SimpleStorage();
        simplestoragearray.push(simplestorage);
    }

    function sfStore(uint _simplestorageIndex, uint _simplestorageNumber) public {
        // Address 
        // ABI 
        simplestoragearray[_simplestorageIndex].store(_simplestorageNumber);
    }
    
    function sfGet(uint _simplestorageIndex) public view returns (uint) {
        // return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
        return simplestoragearray[_simplestorageIndex].retrieve();
    }

}