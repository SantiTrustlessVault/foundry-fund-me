// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

// 1. Deploy a mock contract when we are on a local network like Anvil
// 2. Keep track of contract address across different chains.

contract HelperConfig is Script {
    // If we are on a local anvil, we deploy mocks.
    // Otherwise, grab the existing address from the live network.
    NetworkConfig public activeNetworkConfig;

    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_PRICE = 2000e8; // 2000 USD in 8 decimals

    constructor() {
        if (block.chainid == 11155111) {
            // Sepolia
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            // Mainnet
            activeNetworkConfig = getMainnetConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilConfig(); // Default to Sepolia for other networks
        }
    }

    struct NetworkConfig {
        address priceFeed; // ETH/USD priceFeed address
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Sepolia ETH/USD price feed address
        });
        return sepoliaConfig;
    }

    function getMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419 // Mainnet ETH/USD price feed address
        });
        return mainnetConfig;
    }

    function getOrCreateAnvilConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            // If we already have a price feed address, return it
            return activeNetworkConfig;
        }

        
        // 1. Deploy a mock contract
        // 2. Return the mock Address
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed) // Address of the deployed mock contract
        });
        return anvilConfig;
    }
}
