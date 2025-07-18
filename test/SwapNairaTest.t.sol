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

    function test_swapETHToNaira_RevertIfZeroAmount() public {
        vm.prank(user);
        vm.expectRevert("SwapNaira__ZeroAmountProhibited()");
        swapNaira.swapETHToNaira{value: 0}();
    }

    function test_swapETHToNaira_RevertIfRateNotSet() public {
        NairaX newNaira = new NairaX(address(this));

        SwapNaira newSwap = new SwapNaira(address(newNaira));
        
        newNaira.transferOwnership(address(newSwap));

        newSwap.initialize();

        vm.prank(user);
        vm.deal(user, 1 ether);
        vm.expectRevert("SwapNaira__RateNotSet()");
        newSwap.swapETHToNaira{value: 1 ether}();
    }

    function test_setRate_RevertIfZeroRate() public {
        vm.prank(owner);
        vm.expectRevert("SwapNaira__InvalidRate()");
        swapNaira.setRate(address(0), 0);
    }

    // ========== TOKEN TO NAIRAX TESTS ========== //

    function test_swapTokenToNaira() public {
        uint256 btcAmount = 1e18;
        uint256 expectedNaira = (btcAmount * BTC_RATE) / 1 ether;

        vm.startPrank(user);
        tBTC.approve(address(swapNaira), btcAmount);
        swapNaira.swapTokenToNaira(address(tBTC), btcAmount);
        vm.stopPrank();

        assertEq(nairaToken.balanceOf(user), expectedNaira);
        assertEq(tBTC.balanceOf(address(swapNaira)), btcAmount);
    }

    function test_swapTokenToNaira_RevertIfUnsupportedToken() public {
        TestToken unsupportedToken = new TestToken("Unsupported", "UNSP", 1000e18);

        vm.startPrank(user);
        unsupportedToken.approve(address(swapNaira), 1e18);
        vm.expectRevert("SwapNaira__UnsupportedToken()");
        swapNaira.swapTokenToNaira(address(unsupportedToken), 1e18);
        vm.stopPrank();
    }

    function test_SwapTokenToNaira_RevertIfTransferFails() public {
        // User hasn't approved the swap contract
        vm.prank(user);
        vm.expectRevert(
            abi.encodeWithSelector(
                bytes4(keccak256("ERC20InsufficientAllowance(address,uint256,uint256)")),
                address(swapNaira), 0, 1e18
            )
        );

        swapNaira.swapTokenToNaira(address(tBTC), 1e18);
    }

    // ========== ADMIN FUNCTION TESTS ========== //

    function test_SetRate_OnlyOwner() public {
        vm.prank(attacker);

        vm.expectRevert(abi.encodeWithSelector(
            bytes4(keccak256("OwnableUnauthorizedAccount(address)")),
            attacker
        ));

        swapNaira.setRate(address(0), 999);
    }

    function test_SetTokenSupport_OnlyOwner() public {
        vm.prank(attacker);

        vm.expectRevert(abi.encodeWithSelector(
            bytes4(keccak256("OwnableUnauthorizedAccount(address)")),
            attacker
        ));

        swapNaira.setTokenSupport(address(tBTC), false);
    }

    function test_RecoverERC20_OnlyOwner() public {
        // Send some tokens to swap contract
        tBTC.transfer(address(swapNaira), 5e18);

        vm.prank(attacker);
        vm.expectRevert(abi.encodeWithSelector(
            bytes4(keccak256("OwnableUnauthorizedAccount(address)")),
            attacker
        ));

        swapNaira.recoverERC20(address(tBTC), 5e18);
    }

    // ========== REENTRANCY PROTECTION TESTS ========== //

    function test_ReentrancyProtection() public {
        vm.startPrank(owner);
        swapNaira.setTokenSupport(address(nairaToken), true);
        swapNaira.setRate(address(nairaToken), 1e18);
        vm.stopPrank();

        // First Deploy a malicious contract that tries to re-enter
        ReentrancyAttacker reentrancyAttacker = new ReentrancyAttacker(swapNaira, nairaToken);
        vm.deal(address(reentrancyAttacker), 1 ether);

        vm.expectRevert(
            abi.encodeWithSelector(
                bytes4(keccak256("ReentrancyGuardReentrantCall()"))
            )
        );
        reentrancyAttacker.attack();

        vm.prank(owner);
        swapNaira.setTokenSupport(address(nairaToken), false);
    }

    
    
}

// The Malicious contract for reentrancy test

interface MaliciousInterface {
    function onMintReceived() external;
}

contract ReentrancyAttacker is MaliciousInterface {
    SwapNaira public immutable swap;
    NairaX public immutable naira;
    bool private attacking;

    constructor(SwapNaira _swap, NairaX _naira) {
        swap = _swap;
        naira = _naira;
    }

    function attack() external payable {
        swap.swapETHToNaira{value: 1 ether}();
    }

    function onMintReceived() external override {
        if (!attacking) {
            attacking = true;
            naira.approve(address(swap), type(uint256).max);
            swap.swapTokenToNaira(address(naira), 1e18);
        }
    }

    receive() external payable {}
}