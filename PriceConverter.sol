//SPDX-License-Identifier:MIT
pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() internal view returns(uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
            );
        (, int256 answer, , ,) = pricefeed.latestRoundData();
        return uint256(answer * 1_00000_00000) ;
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethAmount * ethPrice) / 1e18;
        return ethAmountInUSD;
    }
}