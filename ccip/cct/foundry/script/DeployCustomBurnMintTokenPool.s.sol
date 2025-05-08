// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {HelperUtils} from "./utils/HelperUtils.s.sol"; // Utility functions for JSON parsing and chain info
import {HelperConfig} from "./HelperConfig.s.sol"; // Network configuration helper
import {CustomBurnMintTokenPool} from "../src/CustomBurnMintTokenPool.sol";
import {BurnMintERC677} from "@chainlink/contracts-ccip/src/v0.8/shared/token/ERC677/BurnMintERC677.sol";
import {IBurnMintERC20} from "@chainlink/contracts-ccip/src/v0.8/shared/token/ERC20/IBurnMintERC20.sol";
import {IOwnable} from "./utils/IOwnable.sol";
import {IChildToken} from "../src/IChildToken.sol";

contract DeployCustomBurnMintTokenPool is Script {
    function run() external {
        // Get the chain name based on the current chain ID
        string memory chainName = HelperUtils.getChainName(block.chainid);
        string memory tokenName = vm.envString("TOKEN_NAME");

        // Construct the path to the deployed token JSON file
        string memory root = vm.projectRoot();
        string memory deployedTokenPath = string.concat(root, "/script/output/deployedToken", ".json");

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

        // Cast the token address to the IBurnMintERC20 interface
        IBurnMintERC20 token = IBurnMintERC20(tokenAddress);

        vm.startBroadcast();

        // Deploy the BurnMintTokenPool contract associated with the token
        CustomBurnMintTokenPool tokenPool = new CustomBurnMintTokenPool(
            token,
            18, // The number of decimals of the token
            new address[](0), // Empty array for initial operators
            rmnProxy,
            router
        );

        console.log("CustomBurn & Mint token pool deployed to:", address(tokenPool));

        // TODO: For Tokens that are BurnMintERC677, to grant mint and burn roles to the token pool,
        /**
         * Grant mint and burn roles to the token pool on the token contract
         * BurnMintERC677(tokenAddress).grantMintAndBurnRoles(address(tokenPool));
         * console.log("Granted mint and burn roles to token pool:", address(tokenPool));
         */

        // TODO: For Tokens that are ChildERC20, to grant mint and burn roles to the token pool,
        /**
         * In case of ChildERC20, to grant mint and burn roles to the token pool,
         * the token pool should be given the DEPOSITOR_ROLE..
         */
        IChildToken(tokenAddress).grantRole(keccak256("DEPOSITOR_ROLE"), address(tokenPool));
        console.log("Granted DEPOSITOR_ROLE to token pool:", address(tokenPool));

        // TODO: For Tokens that are not BurnMintERC677, the ownership of the token should be transferred to the token pool
        /**
         * Since, the deployed token is not BurnMintERC677, hence, transferring the ownership of the token to the token pool
         * will grant the mint and burn roles to the token pool.
         *
         *     IOwnable(tokenAddress).transferOwnership(address(tokenPool));
         *     console.log("Granted mint and burn roles to token pool:", address(tokenPool));
         *     vm.stopBroadcast();
         */

        // Serialize and write the token pool address to a new JSON file
        string memory jsonObj = "internal_key";
        string memory key = string(abi.encodePacked("deployedTokenPool_", chainName, ".", tokenName));
        string memory finalJson = vm.serializeAddress(jsonObj, key, address(tokenPool));

        string memory poolFileName =
            string(abi.encodePacked("./script/output/deployedTokenPool_", chainName, ".", tokenName, ".json"));
        console.log("Writing deployed token pool address to file:", poolFileName);
        vm.writeJson(finalJson, poolFileName);
    }
}
