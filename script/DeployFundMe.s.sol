pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script {
	function run() external returns (FundMe) {
		HelperConfig helperConfig = new HelperConfig();
		address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
// 		 address ethUsdPriceFeed = helperConfig.localNetworkConfig(); // for this one, maybe because there is different return type https://github.com/Cyfrin/foundry-fund-me-cu/blob/main/script/HelperConfig.s.sol
	
		vm.startBroadcast();
		FundMe fundMe = new FundMe(ethUsdPriceFeed);
		vm.stopBroadcast();

		return fundMe;
	}
}

