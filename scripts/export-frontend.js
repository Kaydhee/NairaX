'use strict';

const fs = require('fs');
const path = require('path');

// const logFile = 'broadcast/Deploy.s.sol/31337/run-latest.json';
const logFile = 'broadcast/Deploy.s.sol/11155111/run-latest.json';

const outAbiDir = 'frontend/src/abi';
const outAddrFile = 'frontend/src/contracts.json';

const contractNames = ['SwapNaira', 'NairaX', 'TestToken'];

const addresses = {};

const artifactDir = 'out';

try {
	const data = JSON.parse(fs.readFileSync(logFile, 'utf8'));
	const logs = data.transactions;

	logs.forEach((tx) => {
		if (!tx.contractName) return;
		if (!contractNames.includes(tx.contractName)) return;

		addresses[tx.contractName] = tx.contractAddress;

		const abiPath = path.join(
			artifactDir,
			`${tx.contractName}.sol`,
			`${tx.contractName}.json`
		);
		const abiJson = JSON.parse(fs.readFileSync(abiPath, 'utf8'));
		const abiOutPath = path.join(outAbiDir, `${tx.contractName}.json`);

		fs.mkdirSync(outAbiDir, { recursive: true });
		fs.writeFileSync(abiOutPath, JSON.stringify(abiJson.abi, null, 2));
	});

	fs.writeFileSync(outAddrFile, JSON.stringify(addresses, null, 2));

	console.log('ABIs and addresses exported successfully to frontend');
} catch (error) {
	console.error('I failed ou master, couldnt export files:', error.message);
}
