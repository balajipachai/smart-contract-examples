// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "./RLPReader.sol";

contract LogConstructor {
    using RLPReader for bytes;
    using RLPReader for RLPReader.RLPItem;

    bytes32 public constant TRANSFER_EVENT_SIG = keccak256("Transfer(address,address,uint256)");

    /**
     * @dev Construct the RLP-encoded log data
     */
    function constructLog(address from, address contractAddressEmittingTheLog, uint256 amount)
        public
        pure
        returns (bytes memory)
    {
        bytes32 topic0 = TRANSFER_EVENT_SIG;
        bytes32 topic1 = bytes32(uint256(uint160(from)));
        bytes32 topic2 = bytes32(uint256(0)); // Expected to be zero address

        // Encode topics as individual RLP items
        bytes memory topic0Encoded = encodeSingleItem(abi.encodePacked(topic0));
        bytes memory topic1Encoded = encodeSingleItem(abi.encodePacked(topic1));
        bytes memory topic2Encoded = encodeSingleItem(abi.encodePacked(topic2));

        // Encode topics as a list of items
        bytes memory topicsList = encodeList([topic0Encoded, topic1Encoded, topic2Encoded]);

        // Data field: encoded amount as a single RLP item
        bytes memory data = encodeSingleItem(abi.encode(amount));

        // Construct the full log
        bytes memory log = encodeList(
            [
                encodeSingleItem(abi.encodePacked(contractAddressEmittingTheLog)), // Contract address
                topicsList, // Topics as a nested RLP list
                data // Data as a single RLP item
            ]
        );

        return log;
    }

    /**
     * @dev Encodes a single RLP item
     */
    function encodeSingleItem(bytes memory item) internal pure returns (bytes memory) {
        if (item.length == 1 && uint8(item[0]) < 0x80) {
            return item; // Single byte, no additional length byte needed
        }
        return abi.encodePacked(encodeLength(item.length, 0x80), item);
    }

    /**
     * @dev Encodes a list of RLP items as a single RLP list.
     */
    function encodeList(bytes[3] memory items) internal pure returns (bytes memory) {
        bytes memory encoded;
        for (uint256 i = 0; i < items.length; i++) {
            encoded = abi.encodePacked(encoded, items[i]);
        }
        return abi.encodePacked(encodeLength(encoded.length, 0xc0), encoded);
    }

    /**
     * @dev Encodes the length for RLP encoding.
     */
    function encodeLength(uint256 len, uint256 offset) internal pure returns (bytes memory) {
        if (len < 56) {
            return abi.encodePacked(uint8(len + offset));
        } else {
            uint256 lenOfLen;
            uint256 tempLen = len;
            while (tempLen != 0) {
                lenOfLen++;
                tempLen /= 256;
            }

            bytes memory lenBytes = new bytes(lenOfLen);
            for (uint256 i = lenOfLen; i > 0; i--) {
                lenBytes[i - 1] = bytes1(uint8(len));
                len /= 256;
            }

            return abi.encodePacked(uint8(lenOfLen + offset + 55), lenBytes);
        }
    }

    /**
     * @dev Decodes the RLP-encoded log
     */
    function exitTokens(address, address, bytes memory log) public pure returns (bytes32, address, uint256) {
        RLPReader.RLPItem[] memory logRLPList = log.toRlpItem().toList();
        require(logRLPList.length == 3, "Invalid log structure");

        // Topics list
        RLPReader.RLPItem[] memory topics = logRLPList[1].toList();
        require(topics.length == 3, "Invalid topics structure");

        bytes32 eventSig = bytes32(topics[0].toUint());
        require(eventSig == TRANSFER_EVENT_SIG, "Invalid event signature");

        address withdrawer = address(uint160(topics[1].toUint()));
        require(address(uint160(topics[2].toUint())) == address(0), "Invalid receiver");

        uint256 amount = logRLPList[2].toUint();

        return (eventSig, withdrawer, amount);
    }
}
