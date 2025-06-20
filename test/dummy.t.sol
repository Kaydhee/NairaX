// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.20;

// import "forge-std/Script.sol";
// import "../contracts/NairaX.sol";
// import "../contracts/SwapNaira.sol";
// import "../contracts/TestToken.sol";

// contract DeployScript is Script {
//     function run() external {
//         // Load private key from .env (set via --private-key or ENV var)
//         uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

//         vm.startBroadcast(deployerPrivateKey);

//         // 1. Deploy NairaX
//         NairaX nairaToken = new NairaX();
//         console.log("✅ NairaX deployed to:", address(nairaToken));

//         // 2. Deploy SwapNaira
//         SwapNaira swap = new SwapNaira(address(nairaToken));
//         console.log("✅ SwapNaira deployed to:", address(swap));

//         // 3. Transfer ownership of NairaX to Swap contract
//         nairaToken.transferOwnership(address(swap));

//         // 4. (Optional) Deploy dummy TestBTC
//         TestToken tBTC = new TestToken("Test Bitcoin", "tBTC", 1_000_000e18);
//         console.log("✅ TestBTC deployed to:", address(tBTC));

//         // 5. Set exchange rates
//         // ETH: address(0)
//         swap.setRate(address(0), 1_000_000e18); // 1 ETH = ₦1,000,000
//         swap.setRate(address(tBTC), 92_000_000e18); // 1 tBTC = ₦92,000,000

//         // 6. Register tBTC as supported token
//         swap.addSupportedToken(address(tBTC));

//         vm.stopBroadcast();
//     }
// }
