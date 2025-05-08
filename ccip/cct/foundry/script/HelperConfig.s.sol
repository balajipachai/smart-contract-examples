// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        uint64 chainSelector;
        address router;
        address rmnProxy;
        address tokenAdminRegistry;
        address registryModuleOwnerCustom;
        address link;
        uint256 confirmations;
        string nativeCurrencySymbol;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getEthereumSepoliaConfig();
        } else if (block.chainid == 157) {
            activeNetworkConfig = getPuppynetConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getEthereumMainnetConfig();
        } else if (block.chainid == 10) {
            activeNetworkConfig = getOptimismConfig();
        } else if (block.chainid == 59144) {
            activeNetworkConfig = getLineaConfig();
        } else if (block.chainid == 81457) {
            activeNetworkConfig = getBlastConfig();
        } else if (block.chainid == 8453) {
            activeNetworkConfig = getBaseConfig();
        } else if (block.chainid == 43114) {
            activeNetworkConfig = getAvalancheConfig();
        } else if (block.chainid == 56) {
            activeNetworkConfig = getBscConfig();
        } else if (block.chainid == 137) {
            activeNetworkConfig = getPolygonConfig();
        } else if (block.chainid == 100) {
            activeNetworkConfig = getGnosisConfig();
        } else if (block.chainid == 5000) {
            activeNetworkConfig = getMantleConfig();
        } else if (block.chainid == 42220) {
            activeNetworkConfig = getCeloConfig();
        } else if (block.chainid == 534352) {
            activeNetworkConfig = getScrollConfig();
        } else {
            revert("Unsupported chain ID");
        }
    }

    function getEthereumSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethereumSepoliaConfig = NetworkConfig({
            chainSelector: 16015286601757825753,
            router: 0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59,
            rmnProxy: 0xba3f6251de62dED61Ff98590cB2fDf6871FbB991,
            tokenAdminRegistry: 0x95F29FEE11c5C55d26cCcf1DB6772DE953B37B82,
            registryModuleOwnerCustom: 0x62e731218d0D47305aba2BE3751E7EE9E5520790,
            link: 0x779877A7B0D9E8603169DdbD7836e478b4624789,
            confirmations: 2,
            nativeCurrencySymbol: "ETH"
        });
        return ethereumSepoliaConfig;
    }

    function getPuppynetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory puppynetConfig = NetworkConfig({
            chainSelector: 17833296867764334567,
            router: 0x449E234FEDF3F907b9E9Dd6BAf1ddc36664097E5,
            rmnProxy: 0x8d677784DA3707e57aC0306464552560E05dBCD7,
            tokenAdminRegistry: 0x5B3BA3d2Dbe9565c2905fbB81776E332a59b6F05,
            registryModuleOwnerCustom: 0xf6B25A05333C4B8Eb108758d306f28B99324A1bf,
            link: 0x44637eEfD71A090990f89faEC7022fc74B2969aD,
            confirmations: 2,
            nativeCurrencySymbol: "ETH"
        });
        return puppynetConfig;
    }

    function getShibariumConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory shibariumConfig = NetworkConfig({
            chainSelector: 3993510008929295315,
            router: 0xc2CA5d5C17911e4B838194b51585DdF8fe5116C1,
            rmnProxy: 0xD2bdb98dA1Ff575d091CA5b76412C23Cba88CA02,
            tokenAdminRegistry: 0x995d2Aa233aBeaCA2a64Edf898AE9F4e01bE15B9,
            registryModuleOwnerCustom: 0x1f524a11d89D68a4E4b1c8A195E91Fb1d8f0B56a,
            link: 0x71052BAe71C25C78E37fD12E5ff1101A71d9018F,
            confirmations: 2,
            nativeCurrencySymbol: "BONE"
        });
        return shibariumConfig;
    }

    function getEthereumMainnetConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethereumMainnetConfig = NetworkConfig({
            chainSelector: 5009297550715157269,
            router: 0x80226fc0Ee2b096224EeAc085Bb9a8cba1146f7D,
            rmnProxy: 0x411dE17f12D1A34ecC7F45f49844626267c75e81,
            tokenAdminRegistry: 0xb22764f98dD05c789929716D677382Df22C05Cb6,
            registryModuleOwnerCustom: 0x4855174E9479E211337832E109E7721d43A4CA64,
            link: 0x514910771AF9Ca656af840dff83E8264EcF986CA,
            confirmations: 2,
            nativeCurrencySymbol: "ETH"
        });
        return ethereumMainnetConfig;
    }

    function getOptimismConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory optimismConfig = NetworkConfig({
            chainSelector: 3734403246176062136,
            router: 0x3206695CaE29952f4b0c22a169725a865bc8Ce0f,
            rmnProxy: 0x55b3FCa23EdDd28b1f5B4a3C7975f63EFd2d06CE,
            tokenAdminRegistry: 0x657c42abE4CD8aa731Aec322f871B5b90cf6274F,
            registryModuleOwnerCustom: 0xAFEd606Bd2CAb6983fC6F10167c98aaC2173D77f,
            link: 0x350a791Bfc2C21F9Ed5d10980Dad2e2638ffa7f6,
            confirmations: 2,
            nativeCurrencySymbol: "ETH"
        });
        return optimismConfig;
    }

    function getLineaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory lineaConfig = NetworkConfig({
            chainSelector: 4627098889531055414,
            router: 0x549FEB73F2348F6cD99b9fc8c69252034897f06C,
            rmnProxy: 0x1F8fbCf559f08FE7c4076f0d68DB861e1E27f95b,
            tokenAdminRegistry: 0xBc933cEE67d2b1c08490ee8C51E2dF653a713534,
            registryModuleOwnerCustom: 0x0a12ec21c43ab2b4f69693Da1b0149e7652689c0,
            link: 0xa18152629128738a5c081eb226335FEd4B9C95e9,
            confirmations: 2,
            nativeCurrencySymbol: "ETH"
        });
        return lineaConfig;
    }

    function getBlastConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory blastConfig = NetworkConfig({
            chainSelector: 4411394078118774322,
            router: 0x12e0B8E349C6fb7E6E40713E8125C3cF1127ea8C,
            rmnProxy: 0x50dbd1e73ED032f42B5892E5F3689972FefAc880,
            tokenAdminRegistry: 0x846Fccd01D4115FD1E81267495773aeB33bF1dC7,
            registryModuleOwnerCustom: 0xb227f007804c16546Bd054dfED2E7A1fD5437678,
            link: 0x93202eC683288a9EA75BB829c6baCFb2BfeA9013,
            confirmations: 2,
            nativeCurrencySymbol: "ETH"
        });
        return blastConfig;
    }

    function getBaseConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory baseConfig = NetworkConfig({
            chainSelector: 15971525489660198786,
            router: 0x881e3A65B4d4a04dD529061dd0071cf975F58bCD,
            rmnProxy: 0xC842c69d54F83170C42C4d556B4F6B2ca53Dd3E8,
            tokenAdminRegistry: 0x6f6C373d09C07425BaAE72317863d7F6bb731e37,
            registryModuleOwnerCustom: 0xAFEd606Bd2CAb6983fC6F10167c98aaC2173D77f,
            link: 0x88Fb150BDc53A65fe94Dea0c9BA0a6dAf8C6e196,
            confirmations: 2,
            nativeCurrencySymbol: "ETH"
        });
        return baseConfig;
    }

    function getAvalancheConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory avalancheConfig = NetworkConfig({
            chainSelector: 6433500567565415381,
            router: 0xF4c7E640EdA248ef95972845a62bdC74237805dB,
            rmnProxy: 0xcBD48A8eB077381c3c4Eb36b402d7283aB2b11Bc,
            tokenAdminRegistry: 0xc8df5D618c6a59Cc6A311E96a39450381001464F,
            registryModuleOwnerCustom: 0x76Aa17dCda9E8529149E76e9ffaE4aD1C4AD701B,
            link: 0x5947BB275c521040051D82396192181b413227A3,
            confirmations: 2,
            nativeCurrencySymbol: "AVAX"
        });
        return avalancheConfig;
    }

    function getBscConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory bscConfig = NetworkConfig({
            chainSelector: 11344663589394136015,
            router: 0x34B03Cb9086d7D758AC55af71584F81A598759FE,
            rmnProxy: 0x9e09697842194f77d315E0907F1Bda77922e8f84,
            tokenAdminRegistry: 0x736Fd8660c443547a85e4Eaf70A49C1b7Bb008fc,
            registryModuleOwnerCustom: 0x47Db76c9c97F4bcFd54D8872FDb848Cab696092d,
            link: 0x404460C6A5EdE2D891e8297795264fDe62ADBB75,
            confirmations: 2,
            nativeCurrencySymbol: "BNB"
        });
        return bscConfig;
    }

    function getPolygonConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory polygonConfig = NetworkConfig({
            chainSelector: 4051577828743386545,
            router: 0x849c5ED5a80F5B408Dd4969b78c2C8fdf0565Bfe,
            rmnProxy: 0xf1ceAa46D8d13Cac9fC38aaEF3d3d14754C5A9c2,
            tokenAdminRegistry: 0x00F027eA6D0fb03256A15E9182B2B9227A4931d8,
            registryModuleOwnerCustom: 0xc751E86208F0F8aF2d5CD0e29716cA7AD98B5eF5,
            link: 0xb0897686c545045aFc77CF20eC7A532E3120E0F1,
            confirmations: 2,
            nativeCurrencySymbol: "POL"
        });
        return polygonConfig;
    }

    function getGnosisConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory gnosisConfig = NetworkConfig({
            chainSelector: 465200170687744372,
            router: 0x4aAD6071085df840abD9Baf1697d5D5992bDadce,
            rmnProxy: 0xf5e5e1676942520995c1e39aFaC58A75Fe1cd2bB,
            tokenAdminRegistry: 0x73BC11423CBF14914998C23B0aFC9BE0cb5B2229,
            registryModuleOwnerCustom: 0x1f524a11d89D68a4E4b1c8A195E91Fb1d8f0B56a,
            link: 0xE2e73A1c69ecF83F464EFCE6A5be353a37cA09b2,
            confirmations: 2,
            nativeCurrencySymbol: "XDAI"
        });
        return gnosisConfig;
    }

    function getMantleConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mantleConfig = NetworkConfig({
            chainSelector: 1556008542357238666,
            router: 0x670052635a9850bb45882Cb2eCcF66bCff0F41B7,
            rmnProxy: 0x91E2186E93F0ECeDDCdf9850078F104daB085E79,
            tokenAdminRegistry: 0x000A744940eB5D857c0d61d97015DFc83107404F,
            registryModuleOwnerCustom: 0xf49f81b3d2F2a79b706621FA2D5934136352140c,
            link: 0xfe36cF0B43aAe49fBc5cFC5c0AF22a623114E043,
            confirmations: 2,
            nativeCurrencySymbol: "MNT"
        });
        return mantleConfig;
    }

    function getCeloConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory celoConfig = NetworkConfig({
            chainSelector: 1346049177634351622,
            router: 0xfB48f15480926A4ADf9116Dca468bDd2EE6C5F62,
            rmnProxy: 0x56e0507d4E69D98bE7Eb4ada01d2315596F9f281,
            tokenAdminRegistry: 0xf19e0555fAA9051e277eeD5A0DcdB13CDaca39a9,
            registryModuleOwnerCustom: 0xb0112a2723D9D6CB5194580701A93B1eb67846D2,
            link: 0xd07294e6E917e07dfDcee882dd1e2565085C2ae0,
            confirmations: 2,
            nativeCurrencySymbol: "CELO"
        });
        return celoConfig;
    }

    function getScrollConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory scrollConfig = NetworkConfig({
            chainSelector: 13204309965629103672,
            router: 0x9a55E8Cab6564eb7bbd7124238932963B8Af71DC,
            rmnProxy: 0x68B38980aD70650a6f3229BA156e5c1F88A21320,
            tokenAdminRegistry: 0x846dEA1c1706FC35b4aa78B32d31F1599DAA47b4,
            registryModuleOwnerCustom: 0x3539F2E214d8BC7E611056383323aC6D1b01943c,
            link: 0x548C6944cba02B9D1C0570102c89de64D258d3Ac,
            confirmations: 2,
            nativeCurrencySymbol: "ETH"
        });
        return scrollConfig;
    }
}
