// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PriceConverter.sol";

//Get fund from users
//withdraw funds
//set a minimum funding value in USD

contract FundMe{
    using PriceConverter for uint;

    address[] public funders;
    mapping (address => uint) public addressToAmtFunded;

    address public immutable owner;
    constructor() {
        owner = msg.sender;
    }

    //constant and immutable keyword reduces gascost
    uint public constant minUSD = 50 * 1e18; //1eth =1e18 wei
    function fund() public payable {//payable makes the function hold BC token(like wallet)
        //suppose that min 1 eth funding is required
        //require(msg.value >= 1e18,"Not enough funding"); //1e18 == 10^18(wei)
        //if msg.value is <1e18 then "Not enough funding" msg will be displayed and the function will be revert
        //it means all changes made inside this function are undo
        // require(getConversionRate(msg.value) >= minUSD,"Not enough funding");
        require(msg.value.getConversionRate() >= minUSD,"Not enough funding");
        funders.push(msg.sender);
        addressToAmtFunded[msg.sender] += msg.value;
    }

    // function getPrice() public view returns(uint){
    // /*
    //  * Network: Sepolia
    //  * Aggregator: ETH/USD
    //  * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
    //  */
    //     AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    //     (/* uint80 roundID */,
    //         int answer,
    //         /*uint startedAt*/,
    //         /*uint timeStamp*/,
    //         /*uint80 answeredInRound*/
    //     ) = priceFeed.latestRoundData();
    //     //$3862.00000000
    //     return uint(answer * 1e10); //typecasting done as minUSD is uint
    //     //msg.value is 10^18 whereas answer will have 8 decimal places, so we'll convert it by mul 10^10
    // }

    // function getConversionRate(uint ethAmt) public view returns(uint){
    //     uint ethPrice = getPrice();
    //     uint ethAmtinUSD = (ethPrice * ethAmt) / 1e18; //both price and amt is 1e18 hence amtinusd will be 1e36, hence div by 1e18
    //     return ethAmtinUSD;
    // }

    function withdraw() public onlyOwner{
        //method 1:
        //require(owner == msg.sender,"Only owner can withdraw funds");

        for (uint i=0; i<funders.length; i++) {
            address funder = funders[i];
            addressToAmtFunded[funder] = 0;
        }
        //reset the array of funders as all amt is now funded and withdrawn
        funders = new address[](0);//funders is now new array with 0 length
        
        //withdrawing funds by 3 way
        //1.Transfer
        // payable(msg.sender).transfer(address(this).balance); //this refers to the contract
        //here msg.sender is just an address so we typecast it to payable so that it can hold back the balance
        //2.Send
        // bool confirmation = payable(msg.sender).send(address(this).balance);
        // require(confirmation,"Send Failed");
        //if txn fails in transfer it will throw error and txn revert
        //if txn fails in send it won't throw error, hence we use require fxn
        //3.Call
        (bool callsuccess, /*bytes memory dataReturned*/) = payable(msg.sender).call{value: address(this).balance}("");
        require(callsuccess,"Call Failed");
        //call is used to call any fxn virtually
        //here we dont wanna call any fxn hence ("") is empty
    }
    //modifier will first check the condition and then continue(_;) to the rest of code of fxn 
    modifier onlyOwner{
        require(owner == msg.sender,"Only owner can withdraw funds");
        _;
    }
    //by using recieve fxn we can directly recieve tokens on our contract address, no need run fund fxn
    receive() external payable {
        fund();
    }

    fallback() external payable{
        fund();
    }
}