//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract SimpleStorage {
     uint256 myfavoriteNumber;

     struct Person{
         uint256 my_favorite_number;
         string name;
     }
    // uint256[] public anArray ; 
    Person[] public list_of_people;

     mapping(string => uint256) public nametoFavoriteNumber;

     function store(uint256 _favoriteNumber) public virtual {
        myfavoriteNumber = _favoriteNumber;
     }

     function retrieve() public view returns(uint256){
        return myfavoriteNumber;
     }

     function add_person(string memory _name, uint256 _favorite_number) public {
         list_of_people.push(Person(_favorite_number, _name));
         nametoFavoriteNumber[_name] = _favorite_number;
     }



}