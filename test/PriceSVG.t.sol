// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import {PriceSVG} from "../src/PriceSVG.sol";

contract PriceSVGTest is Test {
    PriceSVG private priceSvg;
    address private immutable stranger = address(0xBEEF);

    function setUp() public {
        priceSvg = new PriceSVG();
    }

    function testOwnerCanSetAndUpdatePrice() public {
        priceSvg.setPrice("ETH", 1800);
        (int256 priceOne, bool exists) = priceSvg.priceOf("ETH");
        assertTrue(exists);
        assertEq(priceOne, 1800);

        priceSvg.setPrice("ETH", 1900);
        (int256 priceTwo, ) = priceSvg.priceOf("ETH");
        assertEq(priceTwo, 1900);

        string[] memory names = priceSvg.symbols();
        assertEq(names.length, 1);
        assertEq(names[0], "ETH");
    }

    function testNonOwnerCannotSetPrice() public {
        vm.prank(stranger);
        vm.expectRevert(PriceSVG.NotOwner.selector);
        priceSvg.setPrice("WBTC", 30_000);
    }

    function testRevertsWhenSymbolEmpty() public {
        vm.expectRevert(PriceSVG.EmptySymbol.selector);
        priceSvg.setPrice("", 10);
    }

    function testSvgRevertsWhenNoPrices() public {
        vm.expectRevert(PriceSVG.NoPrices.selector);
        priceSvg.svg();
    }

    function testSvgContainsAllRows() public {
        priceSvg.setPrice("ETH", 1800);
        priceSvg.setPrice("USDC", 1);
        string memory image = priceSvg.svg();

        assertGt(bytes(image).length, 0);
        assertTrue(_contains(image, "Token Prices"));
        assertTrue(_contains(image, "ETH: 1800"));
        assertTrue(_contains(image, "USDC: 1"));
        assertTrue(_contains(image, 'width="420"'));
    }

    function _contains(string memory haystack, string memory needle) internal pure returns (bool) {
        bytes memory h = bytes(haystack);
        bytes memory n = bytes(needle);
        if (n.length == 0 || n.length > h.length) return false;

        for (uint256 i = 0; i <= h.length - n.length; i++) {
            bool matchFound = true;
            for (uint256 j = 0; j < n.length; j++) {
                if (h[i + j] != n[j]) {
                    matchFound = false;
                    break;
                }
            }
            if (matchFound) return true;
        }
        return false;
    }
}
