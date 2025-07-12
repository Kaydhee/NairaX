import { ethers } from 'ethers';
import contracts from '../contracts.json';
import swapAbi from '../abi/SwapNaira.json';
import { useEffect, useState, useMemo } from 'react';
import PropTypes from 'prop-types';

const tokenList = [
	{
		label: 'ETH',
		id: 'ethereum',
		address: ethers.ZeroAddress,
		decimals: 18,
	},
	{
		label: 'tBTC',
		id: 'bitcoin',
		address: contracts.TestBTC,
		decimals: 18,
	},
];

const SwapForm = ({ signer }) => {
	const [selectedToken, setSelectedToken] = useState(tokenList[0]);
	const [amount, setAmount] = useState('');
	const [nairaAmount, setNairaAmount] = useState('0');
	const [txStatus, setTxStatus] = useState('');
	const [marketPrice, setMarketPrice] = useState(null);
	const [dummyRate, setDummyRate] = useState(null);

	// ✅ memoized contract instance
	const swapContract = useMemo(() => {
		if (!signer) return null;
		return new ethers.Contract(contracts.SwapNaira, swapAbi, signer);
	}, [signer]);

	// 📈 Market price fetcher
	useEffect(() => {
		const fetchPrice = async () => {
			try {
				const res = await fetch(
					`https://api.coingecko.com/api/v3/simple/price?ids=${selectedToken.id}&vs_currencies=ngn`
				);
				const data = await res.json();
				setMarketPrice(data[selectedToken.id]?.ngn || null);
			} catch (err) {
				console.error('Price fetch failed:', err);
			}
		};

		fetchPrice();
	}, [selectedToken]);

	// 💰 Dummy contract rate fetcher
	useEffect(() => {
		const getRate = async () => {
			try {
				if (!swapContract) return;
				const rate = await swapContract.rates(selectedToken.address);
				setDummyRate(Number(ethers.formatEther(rate)));
			} catch (err) {
				console.error('Rate fetch failed:', err);
				setDummyRate(null);
			}
		};

		getRate();
	}, [selectedToken, swapContract]);

	// 🧮 Estimate NairaX output
	useEffect(() => {
		if (!amount || !dummyRate) return;
		const parsed = parseFloat(amount);
		if (!isNaN(parsed)) {
			setNairaAmount((parsed * dummyRate).toFixed(2));
		} else {
			setNairaAmount('0');
		}
	}, [amount, dummyRate]);

	// 🔁 Swap Handler
	const handleSwap = async () => {
		try {
			if (!signer || !swapContract) {
				setTxStatus('❌ Wallet not connected');
				return;
			}

			setTxStatus('⏳ Swapping...');

			if (selectedToken.address === ethers.ZeroAddress) {
				const tx = await swapContract.swapETHToNaira({
					value: ethers.parseEther(amount),
				});
				await tx.wait();
			} else {
				const tokenContract = new ethers.Contract(
					selectedToken.address,
					[
						'function approve(address spender, uint256 amount) public returns (bool)',
					],
					signer
				);
				const parsedAmount = ethers.parseUnits(amount, selectedToken.decimals);
				await tokenContract.approve(swapContract.target, parsedAmount);

				const tx = await swapContract.swapTokenToNaira(
					selectedToken.address,
					parsedAmount
				);
				await tx.wait();
			}

			setTxStatus('✅ Swap Successful!');
		} catch (err) {
			console.error(err);
			setTxStatus('❌ Swap Failed');
		}
	};

	return (
		<section>
			<h2>Swap to NairaX</h2>

			<label>Choose Token:</label>
			<select
				value={selectedToken.label}
				onChange={(e) =>
					setSelectedToken(tokenList.find((t) => t.label === e.target.value))
				}>
				{tokenList.map((token) => (
					<option
						key={token.label}
						value={token.label}>
						{token.label}
					</option>
				))}
			</select>

			<label>Enter Amount ({selectedToken.label}):</label>
			<input
				type='text'
				placeholder='e.g. 0.05'
				value={amount}
				onChange={(e) => setAmount(e.target.value)}
			/>

			<div>
				<p>
					<strong>Market Price:</strong>{' '}
					{marketPrice ? `₦${marketPrice.toLocaleString()}` : 'Loading...'}
				</p>

				<p>
					<strong>Dummy Rate:</strong> ₦{dummyRate ?? 'Loading...'} /{' '}
					{selectedToken.label}
				</p>

				<p>
					<strong>You Receive:</strong> {nairaAmount} NairaX
				</p>

				{marketPrice &&
					dummyRate &&
					Math.abs(marketPrice - dummyRate) > marketPrice * 0.1 && (
						<p style={{ color: 'orange' }}>
							⚠️ Warning: Dummy rate differs significantly from live market.
						</p>
					)}
			</div>

			<button onClick={handleSwap}>Swap</button>
			<p>{txStatus}</p>
		</section>
	);
};

SwapForm.propTypes = {
	signer: PropTypes.object,
};

export default SwapForm;
