/* eslint-disable no-unused-vars */
import { useEffect, useState } from 'react';
import { ethers } from 'ethers';

import LivePrices from './components/LivePrices';
import SwapForm from './components/SwapForm';
import Nav from './components/Nav';
import Hero from './components/Hero';

const App = () => {
	const [provider, setProvider] = useState(null);
	const [signer, setSigner] = useState(null);
	const [account, setAccount] = useState('');

	const connectWallet = async () => {
		try {
			const newProvider = new ethers.BrowserProvider(window.ethereum);
			const newSigner = await newProvider.getSigner();
			const address = await newSigner.getAddress();

			setProvider(newProvider);
			setSigner(newSigner);
			setAccount(address);
		} catch (err) {
			console.error('Wallet connection failed:', err);
		}
	};

	useEffect(() => {
		if (window.ethereum) {
			window.ethereum.request({ method: 'eth_accounts' }).then((accounts) => {
				if (accounts.length > 0) connectWallet();
			});
		}
	}, []);

	return (
		<header className='bg-primary text-white w-full'>
			<Nav
				account={account}
				connectWallet={connectWallet}
			/>
			<Hero />

			<SwapForm signer={signer} />
			<LivePrices />
		</header>
	);
};

export default App;
