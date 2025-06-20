// // // SPDX-License-Identifier: UNLICENSED
// // pragma solidity ^0.8.26;

// // import "forge-std/Test.sol";
// // import "../contracts/SwapNaira.sol";
// // import "../contracts/NairaX.sol";
// // import "../contracts/TestToken.sol";

// // contract SwapNairaTest is Test {
// //     SwapNaira public swapNaira;
// //     NairaX public nairaToken;
// //     TestToken public tBTC;

// //     address public owner = address(this); // test contract is owner
// //     address public user = address(0xBEEF);
// //     address public attacker = address(0xBAD);

// //     uint256 public constant ETH_RATE = 1_000_000e18;      // 1 ETH = 1,000,000 NGN
// //     uint256 public constant BTC_RATE = 92_000_000e18;     // 1 tBTC = 92,000,000 NGN

// //     function setUp() public {
// //         // Deploy contracts
// //         nairaToken = new NairaX(owner);
// //         swapNaira = new SwapNaira(address(nairaToken));
// //         tBTC = new TestToken("Test Bitcoin", "tBTC", 1_000_000e18);

// //         // Initialize the swap contract
// //         swapNaira.initialize();

// //         // Configure rates and supported tokens
// //         swapNaira.setRate(address(0), ETH_RATE);
// //         swapNaira.setRate(address(tBTC), BTC_RATE);
// //         swapNaira.setTokenSupport(address(tBTC), true);

// //         // Fund test users
// //         tBTC.transfer(user, 10e18);
// //         vm.deal(user, 10 ether);
// //     }

// //     // ========== INITIALIZATION TESTS ========== //

// //     function test_Initialization() public {
// //         assertTrue(swapNaira.initialized());
// //         assertEq(nairaToken.minter(), address(swapNaira));
// //     }

// //     function test_CannotSwapBeforeInitialization() public {
// //         SwapNaira newSwap = new SwapNaira(address(nairaToken));
        
// //         vm.prank(user);
// //         vm.expectRevert(abi.encodeWithSignature("ContractNotInitialized()"));
// //         newSwap.swapETHToNaira{value: 1 ether}();
// //     }

// //     // ========== ETH TO NAIRAX TESTS ========== //

// //     function test_SwapETHToNaira() public {
// //         uint256 ethAmount = 1 ether;
// //         uint256 expectedNaira = (ethAmount * ETH_RATE) / 1 ether;

// //         vm.prank(user);
// //         swapNaira.swapETHToNaira{value: ethAmount}();

// //         assertEq(nairaToken.balanceOf(user), expectedNaira);
// //         assertEq(address(swapNaira).balance, ethAmount);
// //     }

// //     function test_SwapETHToNaira_RevertIfZeroAmount() public {
// //         vm.prank(user);
// //         vm.expectRevert(abi.encodeWithSignature("ZeroAmountProhibited()"));
// //         swapNaira.swapETHToNaira{value: 0}();
// //     }

// //     function test_SwapETHToNaira_RevertIfRateNotSet() public {
// //         swapNaira.setRate(address(0), 0); // Clear ETH rate
        
// //         vm.prank(user);
// //         vm.expectRevert(abi.encodeWithSignature("RateNotSet()"));
// //         swapNaira.swapETHToNaira{value: 1 ether}();
// //     }

// //     // ========== TOKEN TO NAIRAX TESTS ========== //

// //     function test_SwapTokenToNaira() public {
// //         uint256 btcAmount = 1e18;
// //         uint256 expectedNaira = (btcAmount * BTC_RATE) / 1 ether;

// //         vm.startPrank(user);
// //         tBTC.approve(address(swapNaira), btcAmount);
// //         swapNaira.swapTokenToNaira(address(tBTC), btcAmount);
// //         vm.stopPrank();

// //         assertEq(nairaToken.balanceOf(user), expectedNaira);
// //         assertEq(tBTC.balanceOf(address(swapNaira)), btcAmount);
// //     }

// //     function test_SwapTokenToNaira_RevertIfUnsupportedToken() public {
// //         TestToken unsupportedToken = new TestToken("Unsupported", "UNSP", 1000e18);
        
// //         vm.startPrank(user);
// //         unsupportedToken.approve(address(swapNaira), 1e18);
// //         vm.expectRevert(abi.encodeWithSignature("UnsupportedToken()"));
// //         swapNaira.swapTokenToNaira(address(unsupportedToken), 1e18);
// //         vm.stopPrank();
// //     }

// //     function test_SwapTokenToNaira_RevertIfTransferFails() public {
// //         // User hasn't approved tokens
// //         vm.prank(user);
// //         vm.expectRevert(abi.encodeWithSignature("TransferFailed()"));
// //         swapNaira.swapTokenToNaira(address(tBTC), 1e18);
// //     }

// //     // ========== ADMIN FUNCTION TESTS ========== //

// //     function test_SetRate_OnlyOwner() public {
// //         vm.prank(attacker);
// //         vm.expectRevert("Ownable: caller is not the owner");
// //         swapNaira.setRate(address(0), 999);
// //     }

// //     function test_SetTokenSupport_OnlyOwner() public {
// //         vm.prank(attacker);
// //         vm.expectRevert("Ownable: caller is not the owner");
// //         swapNaira.setTokenSupport(address(tBTC), false);
// //     }

//     // function test_RecoverERC20_OnlyOwner() public {
//     //     // Send some tokens to swap contract
//     //     tBTC.transfer(address(swapNaira), 5e18);
        
//     //     vm.prank(attacker);
//     //     vm.expectRevert("Ownable: caller is not the owner");
//     //     swapNaira.recoverERC20(address(tBTC), 5e18);
//     // }

//     // ========== REENTRANCY PROTECTION TESTS ========== //

//     function test_ReentrancyProtection_ETH() public {
//         // Deploy malicious contract
//         MaliciousContract attackerContract = new MaliciousContract(swapNaira, nairaToken);
//         vm.deal(address(attackerContract), 1 ether);

//         vm.expectRevert("ReentrancyGuard: reentrant call");
//         attackerContract.attack();
//     }

//     // Helper malicious contract for reentrancy test
//     contract MaliciousContract {
//         SwapNaira public swap;
//         NairaX public naira;
        
//         constructor(SwapNaira _swap, NairaX _naira) {
//             swap = _swap;
//             naira = _naira;
//         }
        
//         function attack() external payable {
//             // First call
//             swap.swapETHToNaira{value: 1 ether}();
            
//             // Reentrant call
//             naira.approve(address(swap), type(uint256).max);
//             swap.swapTokenToNaira(address(naira), 1e18);
//         }
        
//         receive() external payable {}
//     }
// }


