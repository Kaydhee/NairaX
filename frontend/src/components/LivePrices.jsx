import { useEffect, useState } from 'react';

const tokenMap = {
	bitcoin: 'BTC',
	ethereum: 'ETH',
	litecoin: 'LTC',
};

const LivePrices = () => {
	const [prices, setPrices] = useState({});

	useEffect(() => {
		const fetchPrices = async () => {
			try {
				const res = await fetch(
					'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,litecoin&vs_currencies=ngn'
				);

				const data = await res.json();
				setPrices(data);
			} catch (err) {
				console.error('Error fetching prices:', err);
			}
		};

		fetchPrices();

		const interval = setInterval(fetchPrices, 60_000);

		return () => clearInterval(interval);
	}, []);

	return (
		<div>
			<h3>Live Prices (NGN)</h3>
			{Object.entries(tokenMap).map(([id, label]) => (
				<p key={id}>
					{label}: ₦{prices[id]?.ngn?.toLocaleString() || 'Loading...'}{' '}
				</p>
			))}
		</div>
	);
};

export default LivePrices;
