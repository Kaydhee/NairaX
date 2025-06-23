// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.26;

// import {Script, console} from "forge-std/Script.sol";
// import {NairaX} from "../src/NairaX.sol";
// import {SwapNaira} from "../src/SwapNaira.sol";
// import {TestToken} from "../src/TestToken.sol";

// contract DeployScript is Script {
//     // Custom errors
//     error InvalidDeployer(address deployer, uint256 balance);
//     error OwnershipMismatch(address expected, address actual);
//     error UninitializedContract();
//     error ConfigurationFailed(string setting);

//     // Configuration constants
//     uint256 public constant INITIAL_TBTC_SUPPLY = 1_000_000e18;
//     uint256 public constant ETH_TO_NGN_RATE = 1_000_000e18;
//     uint256 public constant BTC_TO_NGN_RATE = 92_000_000e18;

//     function run() external {
//         // 1. Environment setup with checks
//         uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
//         address deployer = vm.addr(deployerPrivateKey);
        
//         if (deployer.balance == 0) {
//             revert InvalidDeployer(deployer, 0);
//         }

//         console.log("\n=== Deployment Started ===");
//         console.log("Deployer Address:", deployer);
//         console.log("Deployer Balance:", deployer.balance / 1e18, "ETH");

//         vm.startBroadcast(deployerPrivateKey);

//         // 2. Contract deployment with verification
//         console.log("\n[1/4] Deploying NairaX...");
//         NairaX nairaToken = new NairaX(deployer);
//         if (nairaToken.owner() != deployer) {
//             revert OwnershipMismatch(deployer, nairaToken.owner());
//         }
//         console.log("✓ NairaX deployed to:", address(nairaToken));

//         console.log("\n[2/4] Deploying SwapNaira...");
//         SwapNaira swap = new SwapNaira(address(nairaToken));
//         console.log("✓ SwapNaira deployed to:", address(swap));

//         // 3. Configuration with error handling
//         console.log("\n[3/4] Configuring Contracts...");
//         nairaToken.transferOwnership(address(swap));
//         if (nairaToken.owner() != address(swap)) {
//             revert OwnershipMismatch(address(swap), nairaToken.owner());
//         }
        
//         swap.initialize();
//         if (!swap.initialized()) {
//             revert UninitializedContract();
//         }

//         console.log("\n[4/4] Deploying Test Tokens...");
//         TestToken tBTC = new TestToken("Test Bitcoin", "tBTC", INITIAL_TBTC_SUPPLY);
//         console.log("✓ TestBTC deployed to:", address(tBTC));

//         // 4. Exchange configuration
//         try swap.setRate(address(0), ETH_TO_NGN_RATE) {
//             // Success
//         } catch {
//             revert ConfigurationFailed("ETH rate");
//         }

//         try swap.setRate(address(tBTC), BTC_TO_NGN_RATE) {
//             // Success
//         } catch {
//             revert ConfigurationFailed("BTC rate");
//         }

//         try swap.setTokenSupport(address(tBTC), true) {
//             // Success
//         } catch {
//             revert ConfigurationFailed("Token support");
//         }

//         vm.stopBroadcast();

//         // 5. Final verification
//         console.log("\n=== Deployment Successful ===");
//         console.log("NairaX:", address(nairaToken));
//         console.log("SwapNaira:", address(swap));
//         console.log("TestBTC:", address(tBTC));
//         console.log("\nNext Steps:");
//         console.log("1. Verify contracts (if on live network)");
//         console.log("2. Run tests: forge test");
//     }
// }