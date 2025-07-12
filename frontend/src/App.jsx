import { useEffect, useState, useCallback } from 'react';
import { ethers } from 'ethers';
import swapAbi from './abi/SwapNaira.json';
import tokenAbi from './abi/TestToken.json';
import contracts from './contracts.json';
// import LivePrices from './components/LivePrices';
import SwapForm from './components/SwapForm';

const App = () => {
	const [provider, setProvider] = useState(null);
	const [signer, setSigner] = useState(null);
	const [account, setAccount] = useState('');
	const [amount, setAmount] = useState('');
	const [rate, setRate] = useState('');
	const [token, setToken] = useState('eth');

	const connectWallet = async () => {
		const provider = new ethers.BrowserProvider(window.ethereum);
		const signer = await provider.getSigner();
		const address = await signer.getAddress();

		setProvider(provider);
		setSigner(signer);
		setAccount(address);
	};

	const getRate = useCallback(async () => {
		if (!provider) return;
		const contract = new ethers.Contract(
			contracts.SwapNaira,
			swapAbi,
			provider
		);

		const tokenAddress =
			token === 'eth' ? ethers.ZeroAddress : contracts.TestToken;
		const result = await contract.rates(tokenAddress);
		setRate(ethers.formatEther(result));
	}, [provider, token]);

	const swap = async () => {
		const swap = new ethers.Contract(contracts.SwapNaira, swapAbi, signer);

		const parsedAmount = ethers.parseEther(amount);

		if (token === 'eth') {
			const tx = await swap.swapETHToNaira({ value: parsedAmount });
			await tx.wait();
		} else {
			const tokenContract = new ethers.Contract(
				contracts.TestToken,
				tokenAbi,
				signer
			);

			const allowance = await tokenContract.allowance(
				account,
				contracts.SwapNaira
			);

			if (allowance < parsedAmount) {
				const approveTx = await tokenContract.approve(
					contracts.SwapNaira,
					parsedAmount
				);
				await approveTx.wait();
			}

			const tx = await swap.swapTokenToNaira(contracts.TestToken, parsedAmount);
			await tx.wait();
		}

		alert('Swap successful');
	};

	useEffect(() => {
		getRate();
	}, [getRate]);

	return (
		<div style={{ padding: 20, maxWidth: 480, margin: 'auto' }}>
			<h2>🔁 Swap to NairaX</h2>

			{account ? (
				<p>
					Connected: {account.slice(0, 6)}...{account.slice(-4)}
				</p>
			) : (
				<button onClick={connectWallet}>Connect Wallet</button>
			)}

			<select
				value={token}
				onChange={(e) => setToken(e.target.value)}>
				<option value='eth'>ETH</option>
				<option value='tbtc'>TestBTC</option>
			</select>

			<input
				type='text'
				placeholder='Amount'
				value={amount}
				onChange={(e) => setAmount(e.target.value)}
				style={{ marginTop: 10, width: '100%' }}
			/>

			<p className='text-primary'>
				Rate: 1 {token.toUpperCase()} = ₦{rate}
			</p>

			<button
				onClick={swap}
				disabled={!amount || !account}>
				Swap
			</button>

			{/* <LivePrices /> */}
			<SwapForm signer={signer} />
		</div>
	);
};

export default App;
