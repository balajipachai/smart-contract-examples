// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {HelperUtils} from "./utils/HelperUtils.s.sol"; // Utility functions for JSON parsing and chain info
import {HelperConfig} from "./HelperConfig.s.sol"; // Network configuration helper
import {CustomLockReleaseTokenPoolV2} from "../src/CustomLockReleaseTokenPoolV2.sol";
import {IERC20} from
    "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/interfaces/IERC20.sol";

contract DeployCustomLockReleaseTokenPoolV2 is Script {
    function run() external {
        // Get the chain name based on the current chain ID
        string memory chainName = HelperUtils.getChainName(block.chainid);
        string memory tokenName = vm.envString("TOKEN_NAME");

        address predicate = vm.envAddress("PREDICATE_CONTRACT");

        // Construct the path to the deployed token JSON file
        string memory root = vm.projectRoot();
        string memory deployedTokenPath = string.concat(root, "/script/output/deployedToken.json");

        // Extract the deployed token address from the JSON file
        address tokenAddress = HelperUtils.getAddressFromJson(
            vm, deployedTokenPath, string.concat(".deployedToken_", chainName, ".", tokenName)
        );

        // Fetch network configuration (router and RMN proxy addresses)
        HelperConfig helperConfig = new HelperConfig();
        (, address router, address rmnProxy,,,,,) = helperConfig.activeNetworkConfig();

        // Ensure that the token address, router, and RMN proxy are valid
        require(tokenAddress != address(0), "Invalid token address");
        require(router != address(0) && rmnProxy != address(0), "Router or RMN Proxy not defined for this network");

        vm.startBroadcast();

        // Deploy the LockReleaseTokenPool contract associated with the token
        CustomLockReleaseTokenPoolV2 tokenPool = new CustomLockReleaseTokenPoolV2(
            IERC20(tokenAddress),
            18, // The number of decimals of the token
            new address[](0), // Empty array for initial operators
            rmnProxy,
            false, // Set acceptLiquidity to false
            router,
            predicate
        );

        console.log("Lock & Release token pool deployed to:", address(tokenPool));

        vm.stopBroadcast();
    }
}
