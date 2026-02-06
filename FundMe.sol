//SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe{
    using PriceConverter for uint256;
    
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    /* State Variables */   
    uint256 public constant MINIMUM_USD = 5 * 1e18 ;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINUMUM_USD, "Didn't send enough tokens");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        
    }

    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    modifier onlyOwner {
         if(msg.sender != i_owner){}
            revert NotOwner();
        _;
    }
    
    /* Owner can withdraw all funds  */
    function withdraw() public  onlyOwner {
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
        address funder = funders[funderIndex];
        addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value : address(this).balance}("");
        require(callSuccess, "Call Failed");
        }
    }

    function getLatestPrice() public view returns(uint256){
        ( ,int256 price, , ,) = pricefeed.latestRoundData();
        return uint(price) * 1e10;
    }
    
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
    
}

