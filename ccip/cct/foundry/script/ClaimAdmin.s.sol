// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {HelperUtils} from "./utils/HelperUtils.s.sol"; // Utility functions for JSON parsing and chain info
import {HelperConfig} from "./HelperConfig.s.sol"; // Network configuration helper
import {RegistryModuleOwnerCustom} from
    "@chainlink/contracts-ccip/src/v0.8/ccip/tokenAdminRegistry/RegistryModuleOwnerCustom.sol";
import {BurnMintERC677WithCCIPAdmin} from "../src/BurnMintERC677WithCCIPAdmin.sol";
import {BurnMintERC677} from "@chainlink/contracts-ccip/src/v0.8/shared/token/ERC677/BurnMintERC677.sol";
import {AccessControl} from
    "@chainlink/contracts-ccip/src/v0.8/vendor/openzeppelin-solidity/v5.0.2/contracts/access/AccessControl.sol";

contract ClaimAdmin is Script {
    function run() external {
        // Get the chain name based on the current chain ID
        string memory chainName = HelperUtils.getChainName(block.chainid);
        string memory tokenName = vm.envString("TOKEN_NAME");

        // Define paths to the necessary JSON files
        string memory root = vm.projectRoot();
        string memory deployedTokenPath = string.concat(root, "/script/output/deployedToken" ".json");
        string memory configPath = string.concat(root, "/script/config.json");

        // Extract values from the JSON files
        address tokenAddress = HelperUtils.getAddressFromJson(
            vm, deployedTokenPath, string.concat(".deployedToken_", chainName, ".", tokenName)
        );
        bool withCCIPAdmin = HelperUtils.getBoolFromJson(vm, configPath, ".Token.withGetCCIPAdmin");
        address tokenAdmin = HelperUtils.getAddressFromJson(vm, configPath, ".Token.ccipAdminAddress");

        // Fetch the network configuration
        HelperConfig helperConfig = new HelperConfig();
        (,,,, address registryModuleOwnerCustom,,,) = helperConfig.activeNetworkConfig();

        require(tokenAddress != address(0), "Invalid token address");
        require(registryModuleOwnerCustom != address(0), "Registry module owner custom is not defined for this network");

        vm.startBroadcast();

        // Choose the appropriate admin claim method based on whether the token uses CCIP admin
        if (withCCIPAdmin) {
            claimAdminWithCCIPAdmin(tokenAddress, tokenAdmin, registryModuleOwnerCustom);
        } else {
            claimAdminWithOwner(tokenAddress, registryModuleOwnerCustom);
        }

        vm.stopBroadcast();
    }

    // Claim admin role using the token's CCIP admin
    function claimAdminWithCCIPAdmin(address tokenAddress, address tokenAdmin, address registryModuleOwnerCustom)
        internal
    {
        // Instantiate the token contract with CCIP admin functionality
        BurnMintERC677WithCCIPAdmin tokenContract = BurnMintERC677WithCCIPAdmin(tokenAddress);
        // Instantiate the registry contract
        RegistryModuleOwnerCustom registryContract = RegistryModuleOwnerCustom(registryModuleOwnerCustom);

        // Get the current CCIP admin of the token
        address tokenContractCCIPAdmin = tokenContract.getCCIPAdmin();
        console.log("Current token admin:", tokenContractCCIPAdmin);

        // Ensure the CCIP admin matches the expected token admin address
        require(
            tokenContractCCIPAdmin == tokenAdmin, "CCIP admin of token does not match the token admin address provided."
        );

        // Register the admin via getCCIPAdmin() function
        console.log("Claiming admin of the token via getCCIPAdmin() for CCIP admin:", tokenAdmin);
        registryContract.registerAdminViaGetCCIPAdmin(tokenAddress);
        console.log("Admin claimed successfully for token:", tokenAddress);
    }

    function shouldClaimAdminWithRegisterAccessControlDefaultAdmin(uint256 chainId) internal pure returns (bool) {
        // Since On Below Chains, the token has ChildERC20 and the token does not have either CCIP admin nor owner
        // Hence, in this case, the admin should be registered via AccessControl DEFAULT_ADMIN_ROLE
        /**
         * Optimism: 10
         * Linea: 59144
         * Blast: 81457
         * Ethereum: 1
         * Base: 8453
         * Avalance: 43114
         * BSC: 56
         * Polygon: 137
         * Gnosis: 100
         * Arbitrum: 42161
         * Mantle: 5000
         * Celo: 42220
         * Scroll: 534352
         * Puppynet: 157
         */
        if (
            // TODO: Add Puppynet ChainId, Once RegistryModuleOwnerCustom v1.6.0 is deployed on Puppynet
            chainId == 109 || chainId == 59144 || chainId == 81457 || chainId == 8453 || chainId == 43114
                || chainId == 56 || chainId == 137 || chainId == 100 || chainId == 42161 || chainId == 5000
                || chainId == 42220 || chainId == 534352
        ) {
            return true;
        }
        return false;
    }

    // Claim admin role using the token's owner() function
    function claimAdminWithOwner(address tokenAddress, address registryModuleOwnerCustom) internal {
        // Instantiate the standard token contract
        BurnMintERC677 tokenContract = BurnMintERC677(tokenAddress);
        // Instantiate the registry contract
        RegistryModuleOwnerCustom registryContract = RegistryModuleOwnerCustom(registryModuleOwnerCustom);

        if (shouldClaimAdminWithRegisterAccessControlDefaultAdmin(block.chainid)) {
            // Since it has ChildERC20 and the token does not have either CCIP admin nor owner
            // Hence, in this case, the admin should be registered via AccessControl DEFAULT_ADMIN_ROLE
            bytes32 defaultAdminRole = AccessControl(tokenAddress).DEFAULT_ADMIN_ROLE();
            if (!AccessControl(tokenAddress).hasRole(defaultAdminRole, msg.sender)) {
                console.log("Signer does not have DEFAULT_ADMIN_ROLE");
            }
            registryContract.registerAccessControlDefaultAdmin(tokenAddress);
            console.log("Admin claimed successfully for token:", tokenAddress);
        } else {
            console.log("Current token owner:", tokenContract.owner());
            console.log("Claiming admin of the token via owner() for signer:", msg.sender);
            // Register the admin via owner() function
            registryContract.registerAdminViaOwner(tokenAddress);
            console.log("Admin claimed successfully for token:", tokenAddress);
        }
    }
}
