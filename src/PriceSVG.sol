// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/// @title PriceSVG
/// @notice Stores token prices and renders a simple SVG dashboard.
contract PriceSVG {
    struct Price {
        int256 value;
        bool exists;
        uint256 index;
        string symbol;
    }

    address public immutable owner;
    string[] private _symbols;
    mapping(bytes32 => Price) private _prices;

    event PriceUpdated(string symbol, int256 price);

    error NotOwner();
    error EmptySymbol();
    error NoPrices();

    constructor() {
        owner = msg.sender;
    }

    /// @notice Set or update a token price.
    /// @dev Symbols are case-sensitive. Only the contract deployer can update prices.
    function setPrice(string calldata symbol, int256 price) external {
        if (msg.sender != owner) revert NotOwner();
        if (bytes(symbol).length == 0) revert EmptySymbol();

        bytes32 key = keccak256(bytes(symbol));
        Price storage record = _prices[key];
        if (!record.exists) {
            _prices[key] = Price({value: price, exists: true, index: _symbols.length, symbol: symbol});
            _symbols.push(symbol);
        } else {
            record.value = price;
            record.symbol = symbol;
            _symbols[record.index] = symbol;
        }

        emit PriceUpdated(symbol, price);
    }

    /// @notice Returns price data for a token symbol.
    function priceOf(string calldata symbol) external view returns (int256 price, bool exists) {
        bytes32 key = keccak256(bytes(symbol));
        Price storage record = _prices[key];
        return (record.value, record.exists);
    }

    /// @notice Returns all tracked symbols.
    function symbols() external view returns (string[] memory) {
        return _symbols;
    }

    /// @notice Render an SVG string with all token prices.
    function svg() external view returns (string memory) {
        if (_symbols.length == 0) revert NoPrices();

        uint256 height = 60 + (_symbols.length * 28);
        string memory header = string.concat(
            '<svg xmlns="http://www.w3.org/2000/svg" width="420" height="',
            _toUintString(height),
            '" viewBox="0 0 420 ',
            _toUintString(height),
            '"><style>.title{font:700 16px monospace;fill:#e6edf3;}',
            '.row{font:14px monospace;fill:#e6edf3;}',
            '.badge{font:12px monospace;fill:#7ee787;}</style>',
            '<rect width="100%" height="100%" rx="12" fill="#0d1117" />',
            '<text x="16" y="26" class="title">Token Prices</text>',
            '<text x="320" y="26" class="badge">live</text>'
        );

        string memory body;
        for (uint256 i = 0; i < _symbols.length; i++) {
            bytes32 key = keccak256(bytes(_symbols[i]));
            Price storage record = _prices[key];
            uint256 rowY = 52 + (i * 24);
            body = string.concat(body, _row(record.symbol, record.value, rowY));
        }

        return string.concat(header, body, "</svg>");
    }

    function _row(string memory symbol, int256 price, uint256 y) private pure returns (string memory) {
        return string.concat(
            '<text x="16" y="',
            _toUintString(y),
            '" class="row">',
            symbol,
            ": ",
            _toIntString(price),
            "</text>"
        );
    }

    function _toUintString(uint256 value) private pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + (value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    function _toIntString(int256 value) private pure returns (string memory) {
        if (value == 0) return "0";
        if (value < 0) {
            return string.concat("-", _toUintString(uint256(-value)));
        }
        return _toUintString(uint256(value));
    }
}
