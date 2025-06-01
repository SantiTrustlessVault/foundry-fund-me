// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // address -> of oracle contract
        // 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI -> Aplication Binary Interface
        (, int256 price, , , ) = priceFeed.latestRoundData();

        // "price" devuelve un número con 8 decimales, por ejemplo:
        // price = 300000000000  // equivale a $3000.00000000

        // Para poder trabajar con unidades de wei (que tienen 18 decimales),
        // el contrato ajusta los decimales:
        return uint256(price * 1e10);
    }

    // now we need to convert the eth price value to USD

    function getConversionRate(
        uint256 _ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 _ethPrice = getPrice(priceFeed);
        uint256 ethToUsd = (_ethPrice * _ethAmount) / 1e18;
        return ethToUsd;
    }

    function getVersion(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        return priceFeed.version();
    }
}
