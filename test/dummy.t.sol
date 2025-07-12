// import React, { useEffect, useState } from "react";
// import { ethers } from "ethers";
// import contracts from "../contracts.json";
// import swapAbi from "../abi/SwapNaira.json";

// const tokenList = [
//   {
//     label: "ETH",
//     id: "ethereum",
//     address: ethers.constants.AddressZero,
//     decimals: 18,
//   },
//   {
//     label: "tBTC",
//     id: "bitcoin",
//     address: contracts.TestBTC,
//     decimals: 18,
//   },
// ];

// const SwapForm = ({ provider, signer }) => {
//   const [selectedToken, setSelectedToken] = useState(tokenList[0]);
//   const [amount, setAmount] = useState("");
//   const [nairaAmount, setNairaAmount] = useState("0");
//   const [txStatus, setTxStatus] = useState("");
//   const [marketPrice, setMarketPrice] = useState(null);
//   const [dummyRate, setDummyRate] = useState(null);

//   const swapContract = new ethers.Contract(
//     contracts.SwapNaira,
//     swapAbi,
//     signer
//   );

//   // 📈 Fetch live market price
//   useEffect(() => {
//     const fetchPrice = async () => {
//       try {
//         const res = await fetch(
//           `https://api.coingecko.com/api/v3/simple/price?ids=${selectedToken.id}&vs_currencies=ngn`
//         );
//         const data = await res.json();
//         setMarketPrice(data[selectedToken.id]?.ngn || null);
//       } catch (err) {
//         console.error("Price fetch failed:", err);
//       }
//     };

//     fetchPrice();
//   }, [selectedToken]);

//   // 💰 Fetch dummy contract rate
//   useEffect(() => {
//     const getRate = async () => {
//       try {
//         const rate = await swapContract.getRate(selectedToken.address);
//         setDummyRate(Number(ethers.utils.formatEther(rate)));
//       } catch (err) {
//         console.error("Rate fetch failed:", err);
//         setDummyRate(null);
//       }
//     };

//     if (signer) getRate();
//   }, [selectedToken, signer]);

//   // 🧮 Calculate expected NairaX
//   useEffect(() => {
//     if (!amount || !dummyRate) return;
//     const parsed = parseFloat(amount);
//     if (!isNaN(parsed)) {
//       setNairaAmount((parsed * dummyRate).toFixed(2));
//     } else {
//       setNairaAmount("0");
//     }
//   }, [amount, dummyRate]);

//   const handleSwap = async () => {
//     try {
//       setTxStatus("⏳ Swapping...");
//       if (selectedToken.address === ethers.constants.AddressZero) {
//         const tx = await swapContract.swapToNaira(selectedToken.address, {
//           value: ethers.utils.parseEther(amount),
//         });
//         await tx.wait();
//       } else {
//         const tokenContract = new ethers.Contract(
//           selectedToken.address,
//           [
//             "function approve(address spender, uint256 amount) public returns (bool)",
//           ],
//           signer
//         );
//         const parsedAmount = ethers.utils.parseUnits(amount, selectedToken.decimals);
//         await tokenContract.approve(swapContract.address, parsedAmount);

//         const tx = await swapContract.swapToNaira(selectedToken.address);
//         await tx.wait();
//       }

//       setTxStatus("✅ Swap successful!");
//     } catch (err) {
//       console.error(err);
//       setTxStatus("❌ Swap failed.");
//     }
//   };

//   return (
//     <div className="swap-form">
//       <h2>🔁 Swap to NairaX</h2>

//       <label>Choose Token:</label>
//       <select
//         value={selectedToken.label}
//         onChange={(e) =>
//           setSelectedToken(tokenList.find((t) => t.label === e.target.value))
//         }
//       >
//         {tokenList.map((token) => (
//           <option key={token.label} value={token.label}>
//             {token.label}
//           </option>
//         ))}
//       </select>

//       <label>Enter Amount ({selectedToken.label}):</label>
//       <input
//         type="text"
//         placeholder="e.g. 0.05"
//         value={amount}
//         onChange={(e) => setAmount(e.target.value)}
//       />

//       <div className="rates-info">
//         <p>
//           💹 <strong>Market Price:</strong>{" "}
//           {marketPrice ? `₦${marketPrice.toLocaleString()}` : "Loading..."}
//         </p>
//         <p>
//           🧪 <strong>Dummy Rate:</strong> ₦{dummyRate ?? "Loading..."} / {selectedToken.label}
//         </p>
//         <p>
//           📥 <strong>You Receive:</strong> {nairaAmount} NairaX
//         </p>

//         {marketPrice && dummyRate && Math.abs(marketPrice - dummyRate) > marketPrice * 0.1 && (
//           <p style={{ color: "orange" }}>
//             ⚠️ Warning: Dummy rate differs significantly from live market.
//           </p>
//         )}
//       </div>

//       <button onClick={handleSwap}>Swap</button>
//       <p>{txStatus}</p>
//     </div>
//   );
// };

// export default SwapForm;
