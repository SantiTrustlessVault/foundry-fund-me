// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;


import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

// GAS EFFICIENCY:
// storage: constant, immutable
// error handling: if(){ revert CustomError(); }

error FundMe__NotOwner();
error FundMe__WithdrawCallFailed();

contract FundMe {
    using PriceConverter for uint256;

    // para trabajar en unidades wei
    // 5 dolares * 1e18
    // 5 * 10000000000000000000

    uint256 public constant MINIMUM_USD = 5e18;
    AggregatorV3Interface private s_priceFeed;


    address[] public s_funders;
    mapping(address => uint256) private s_addressToAmount;

    address public immutable i_owner;

    constructor(address priceFeed) {
        s_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender;
    }

    // Ensure that the amount sent is greater than 1 ether
    // 1 ether = 1e18 wei
    // 1e18 = 1000000000000000000 wei
    // to check convert value to wei -> ethereum units converter

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Didn't send enough funds, minimum is 1 ether"
        );
        s_funders.push(msg.sender);
        s_addressToAmount[msg.sender] += msg.value;
    }

    function getVersion() public view returns(uint256){
        return s_priceFeed.version();
    }

    // Debemos resetear el array de funders[]
    // for loop
    // retirar los fondos

    function withdraw() public onlyOwner{
        for (
            uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++
        ) {
            address funder = s_funders[funderIndex];
            s_addressToAmount[funder] = 0;
        }

        // le asignamos al array "funders" un nuevo array
        // que empieza con una longitud de 0
        // Funders = array vacio
        s_funders = new address[](0);

        //transfer
        // limite de gas, si falla se revierte
        // payable(msg.sender).transfer(address(this).balance);

        //send
        // limite de gas, si falla devuelve un bool.
        // No revierte, perdida de fondos
        // para manejar el error(bool) usamos require (revierte)
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "No se pudo enviar el dinero");

        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        // require(callSuccess, "Withdraw call failed");
        if(!callSuccess) { revert FundMe__WithdrawCallFailed(); }
    }

    modifier onlyOwner {
        if( msg.sender != i_owner ){ revert FundMe__NotOwner(); }
        _;
    }

    receive() external payable {
        fund();
     }

     fallback() external payable { 
        fund();
     }

/**
* View / Pure Functions (Getters)   
*/

function getAddressToAmountFunded(
    address fundingAddress
) external view returns(uint256){
    return s_addressToAmount[fundingAddress];
}


function getFunderFromFunders(
    uint256 indexFunder
) public view returns(address){
    return s_funders[indexFunder];
}

function getAddressToAmount(
    address funder
    ) external view returns(uint256){
    return s_addressToAmount[funder];
}

function getOwner() external view returns(address){
    return i_owner;
}



}