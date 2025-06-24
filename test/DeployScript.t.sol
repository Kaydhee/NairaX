// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {DeployScript} from "../script/Deploy.s.sol";
import {NairaX} from "../src/NairaX.sol";
import {SwapNaira} from "../src/SwapNaira.sol";

contract DeployScriptTest is Test {
    DeployScript deployer;
    address constant DEPLOYER_ADDRESS = address(1);

    function setUp() public {
        deployer = new DeployScript();
        // vm.deal(DEPLOYER_ADDRESS, 100 ether);
    }

    function test_DeployAllContracts() public {
        // vm.startPrank(DEPLOYER_ADDRESS);

        deployer.run();

        assertTrue(address(deployer.nairaToken()) != address(0), "NairaX not deployed");
        assertTrue(address(deployer.swap()) != address(0), "SwapNaira not deployed");
        assertTrue(address(deployer.tBTC()) != address(0), "TestBTC not deployed");

    }

    function test_NairaXOwnershipTransferred() public {
        deployer.run();

        NairaX naira = NairaX(address(deployer.nairaToken()));
        SwapNaira swap = SwapNaira(address(deployer.swap()));

        assertEq(naira.owner(), address(swap), "Ownership not transferred");
    }

    function test_SwapInitialized() public {
        deployer.run();

        SwapNaira swap = SwapNaira(address(deployer.swap()));
        assertTrue(swap.initialized(), "Swap not initialized");
    }

    function test_RatesConfigured() public {
        deployer.run();

        SwapNaira swap = SwapNaira(address(deployer.swap()));
        assertGt(swap.rates(address(0)), 0, "ETH rate not set");
        assertGt(swap.rates(address(deployer.tBTC())), 0, "BTC rate not set");
    }

    // function test_RevertIfNoDeployerBalance() public {
    //     vm.startPrank(DEPLOYER_ADDRESS);
    //     vm.deal(DEPLOYER_ADDRESS, 0);
        
    //     vm.expectRevert(
    //         abi.encodeWithSelector(
    //             DeployScript.NairaX__InvalidDeployer.selector,
    //             DEPLOYER_ADDRESS,
    //             0
    //         )
    //     );
    //     deployer.run();
    // }
}