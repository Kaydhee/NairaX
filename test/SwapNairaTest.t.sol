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
    address public attacker = address(0xBAD);

    uint256 public constant ETH_RATE = 1_000_000e18;
    uint256 public constant BTC_RATE = 92_000_000e18;

    function setUp() public {
        // Deploy contracts
        nairaToken = new NairaX(owner);
        swapNaira = new SwapNaira(address(nairaToken));
        tBTC = new TestToken("Test Bitcoin", "tBTC", 1_000_000e18);

        // Initialize the swap contract
        swapNaira.initialize();

        // Configure rates and supported tokens
        swapNaira.setRate(address(0), ETH_RATE);
        swapNaira.setRate(address(tBTC), BTC_RATE);
        swapNaira.setTokenSupport(address(tBTC), true);

        // Funding the test users
        tBTC.transfer(user, 10e18);
        vm.deal(user, 10 ether);
    }

}