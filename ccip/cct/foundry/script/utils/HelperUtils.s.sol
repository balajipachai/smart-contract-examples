// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {stdJson} from "forge-std/StdJson.sol";
import {Vm} from "forge-std/Vm.sol";
import {HelperConfig} from "../HelperConfig.s.sol";

library HelperUtils {
    using stdJson for string;

    function getChainName(uint256 chainId) internal pure returns (string memory) {
        if (chainId == 11155111) {
            return "ethereumSepolia";
        } else if (chainId == 157) {
            return "puppynet";
        } else if (chainId == 1) {
            return "ethereumMainnet";
        } else if (chainId == 10) {
            return "optimism";
        } else if (chainId == 59144) {
            return "linea";
        } else if (chainId == 81457) {
            return "blast";
        } else if (chainId == 8453) {
            return "base";
        } else if (chainId == 43114) {
            return "avalanche";
        } else if (chainId == 56) {
            return "bsc";
        } else if (chainId == 137) {
            return "polygon";
        } else if (chainId == 100) {
            return "gnosis";
        } else if (chainId == 42161) {
            return "arbitrum";
        } else if (chainId == 5000) {
            return "mantle";
        } else if (chainId == 42220) {
            return "celo";
        } else if (chainId == 534352) {
            return "scroll";
        } else {
            revert("Unsupported chain ID");
        }
    }

    function getNetworkConfig(HelperConfig helperConfig, uint256 chainId)
        internal
        pure
        returns (HelperConfig.NetworkConfig memory)
    {
        if (chainId == 11155111) {
            return helperConfig.getEthereumSepoliaConfig();
        } else if (chainId == 157) {
            return helperConfig.getPuppynetConfig();
        } else if (chainId == 109) {
            return helperConfig.getShibariumConfig();
        } else if (chainId == 1) {
            return helperConfig.getEthereumMainnetConfig();
        } else if (chainId == 10) {
            return helperConfig.getOptimismConfig();
        } else if (chainId == 59144) {
            return helperConfig.getLineaConfig();
        } else if (chainId == 81457) {
            return helperConfig.getBlastConfig();
        } else if (chainId == 8453) {
            return helperConfig.getBaseConfig();
        } else if (chainId == 43114) {
            return helperConfig.getAvalancheConfig();
        } else if (chainId == 56) {
            return helperConfig.getBscConfig();
        } else if (chainId == 137) {
            return helperConfig.getPolygonConfig();
        } else if (chainId == 100) {
            return helperConfig.getGnosisConfig();
        } else if (chainId == 5000) {
            return helperConfig.getMantleConfig();
        } else if (chainId == 42220) {
            return helperConfig.getCeloConfig();
        } else if (chainId == 534352) {
            return helperConfig.getScrollConfig();
        } else {
            revert("Unsupported chain ID");
        }
    }

    function getAddressFromJson(Vm vm, string memory path, string memory key) internal view returns (address) {
        string memory json = vm.readFile(path);
        return json.readAddress(key);
    }

    function getBoolFromJson(Vm vm, string memory path, string memory key) internal view returns (bool) {
        string memory json = vm.readFile(path);
        return json.readBool(key);
    }

    function getStringFromJson(Vm vm, string memory path, string memory key) internal view returns (string memory) {
        string memory json = vm.readFile(path);
        return json.readString(key);
    }

    function getUintFromJson(Vm vm, string memory path, string memory key) internal view returns (uint256) {
        string memory json = vm.readFile(path);
        return json.readUint(key);
    }

    function bytes32ToHexString(bytes32 _bytes) internal pure returns (string memory) {
        bytes memory hexString = new bytes(64);
        bytes memory hexAlphabet = "0123456789abcdef";
        for (uint256 i = 0; i < 32; i++) {
            hexString[i * 2] = hexAlphabet[uint8(_bytes[i] >> 4)];
            hexString[i * 2 + 1] = hexAlphabet[uint8(_bytes[i] & 0x0f)];
        }
        return string(hexString);
    }

    function uintToStr(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }
}
