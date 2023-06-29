// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//creating a library
//lib are similar to contract, but u cant declare any state variable and cant send ether
// a lib is embedded into contract if library functions are internal
//otherwise the lib must be deployed and then linked before the contact is deployed

library PriceConverter {

    function getPrice() internal view returns(uint){
    /*
     * Network: Sepolia
     * Aggregator: ETH/USD
     * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
     */
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (/* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
        //$3862.00000000
        return uint(answer * 1e10); //typecasting done as minUSD is uint
        //msg.value is 10^18 whereas answer will have 8 decimal places, so we'll convert it by mul 10^10
    }

    function getConversionRate(uint ethAmt) internal view returns(uint){
        uint ethPrice = getPrice();
        uint ethAmtinUSD = (ethPrice * ethAmt) / 1e18; //both price and amt is 1e18 hence amtinusd will be 1e36, hence div by 1e18
        return ethAmtinUSD;
    }
}