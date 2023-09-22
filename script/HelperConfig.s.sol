//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{
    NetworkConfig public activeNetworkConfig;
    struct NetworkConfig{
        address priceFeed;
    }

    constructor(){
        if(block.chainid==111555111)
        {
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else if(block.chainid==1)
        {
            activeNetworkConfig = getMainEthConfig();
        }
        else{
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x1fcD5c521B6bA68C6f89Fd7DED1708d8c2147F2C
        });
        return sepoliaConfig;
    }

    function getMainEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory mainEthConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return mainEthConfig;
    }

    function getAnvilEthConfig() public returns(NetworkConfig memory){
        if(activeNetworkConfig.priceFeed!=address(0))
        {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8,200e8);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}