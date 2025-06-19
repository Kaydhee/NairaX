// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;
import {Test} from "forge-std/Test.sol";
import {SwapNaira} from "../src/SwapNaira.sol";
import {NairaX} from "../src/NairaX.sol";
import {TestToken} from "../src/TestToken.sol";

contract SwapNairaTest is Test {
    SwapNaira public swapNaira;
    NairaX public nairaToken;
    TestToken public tBTC;

    address public owner = address(this); // test contract is owner
    address public user = address(0xBEEF);
    // address public attacker = address(0xBAD);

    uint256 public constant ETH_RATE = 1_000_000e18;
    uint256 public constant BTC_RATE = 92_000_000e18;

    function setUp() public {
        // Deploy contracts
        nairaToken = new NairaX(owner);
        swapNaira = new SwapNaira(address(nairaToken));
        tBTC = new TestToken("Test Bitcoin", "tBTC", 1_000_000e18);

        // Transfer NairaX ownership to swap contract FIRST
        vm.prank(owner);
        nairaToken.transferOwnership(address(swapNaira));    
        
        // Initialize swap contract
        vm.prank(owner);
        swapNaira.initialize();

        // Configure rates and supported tokens
        vm.prank(owner);
        swapNaira.setRate(address(0), ETH_RATE);
        vm.prank(owner);
        swapNaira.setRate(address(tBTC), BTC_RATE);
        vm.prank(owner);
        swapNaira.setTokenSupport(address(tBTC), true);

        // Funding the test users
        tBTC.transfer(user, 10e18);
        vm.deal(user, 10 ether);
    }

    // ========== INITIALIZATION TESTS ========== //

    function test_Initialization() public view {
        assertTrue(swapNaira.initialized());
        assertEq(nairaToken.minter(), address(swapNaira));
    }

    function test_CannotSwapBeforeInitialization() public {
        SwapNaira newSwap = new SwapNaira(address(nairaToken));

        vm.prank(user);
        vm.expectRevert("SwapNaira__ContractNotInitialized()");
        newSwap.swapETHToNaira{value: 1 ether}();
    }

    // ========== ETH TO NAIRAX TESTS ========== //
    function test_swapETHToNaira() public {
        uint256 ethAmount = 1 ether;
        uint256 expectedNaira = (ethAmount * ETH_RATE) / 1 ether;

        vm.prank(user);
        swapNaira.swapETHToNaira{value: ethAmount}();

        assertEq(nairaToken.balanceOf(user), expectedNaira);
        assertEq(address(swapNaira).balance, ethAmount);
    }

}