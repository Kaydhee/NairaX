// import React, { useState } from 'react';

// const CryptoConverter = () => {
//   const [payAmount, setPayAmount] = useState(10);
//   const [receiveAmount, setReceiveAmount] = useState(126.274);
//   const [payCurrency, setPayCurrency] = useState('INJ');
//   const [receiveCurrency, setReceiveCurrency] = useState('USDT');

//   const handleSwap = () => {
//     const tempAmount = payAmount;
//     const tempCurrency = payCurrency;
//     setPayAmount(receiveAmount);
//     setPayCurrency(receiveCurrency);
//     setReceiveAmount(tempAmount);
//     setReceiveCurrency(tempCurrency);
//     // Add logic to update USD values based on conversion rates if needed
//   };

//   return (
//     <div className="min-h-screen bg-gray-900 flex items-center justify-center p-4">
//       <div className="bg-gray-800 rounded-lg p-6 w-full max-w-md">
//         {/* You Pay Section */}
//         <div classAmount="mb-6">
//           <p className="text-gray-400 text-sm mb-2">You pay</p>
//           <div className="flex items-center justify-between">
//             <input
//               type="number"
//               value={payAmount}
//               onChange={(e) => setPayAmount(e.target.value)}
//               className="bg-transparent text-white text-3xl font-bold w-1/2 outline-none"
//             />
//             <div className="bg-gray-700 rounded-full p-2 flex items-center">
//               <span className="w-6 h-6 bg-blue-500 rounded-full mr-2"></span>
//               <select
//                 value={payCurrency}
//                 onChange={(e) => setPayCurrency(e.target.value)}
//                 className="bg-transparent text-white outline-none"
//               >
//                 <option value="INJ">INJ</option>
//                 <option value="USDT">USDT</option>
//               </select>
//             </div>
//           </div>
//           <p className="text-gray-500 text-sm mt-1">$126.80</p>
//         </div>

//         {/* Swap Button */}
//         <div className="flex justify-center mb-6">
//           <button
//             onClick={handleSwap}
//             className="bg-blue-500 rounded-full p-2 hover:bg-blue-600 transition"
//           >
//             <svg
//               className="w-6 h-6 text-white"
//               fill="none"
//               stroke="currentColor"
//               viewBox="0 0 24 24"
//             >
//               <path
//                 strokeLinecap="round"
//                 strokeLinejoin="round"
//                 strokeWidth="2"
//                 d="M8 7h12m0 0l-4-4m4 4l-4 4m-4 4H4m0 0l4 4m-4-4l4-4"
//               />
//             </svg>
//           </button>
//         </div>

//         {/* You Receive Section */}
//         <div>
//           <p className="text-gray-400 text-sm mb-2">You receive</p>
//           <div className="flex items-center justify-between">
//             <input
//               type="number"
//               value={receiveAmount}
//               onChange={(e) => setReceiveAmount(e.target.value)}
//               className="bg-transparent text-white text-3xl font-bold w-1/2 outline-none"
//             />
//             <div className="bg-gray-700 rounded-full p-2 flex items-center">
//               <span className="w-6 h-6 bg-green-500 rounded-full mr-2"></span>
//               <select
//                 value={receiveCurrency}
//                 onChange={(e) => setReceiveCurrency(e.target.value)}
//                 className="bg-transparent text-white outline-none"
//               >
//                 <option value="USDT">USDT</option>
//                 <option value="INJ">INJ</option>
//               </select>
//             </div>
//           </div>
//           <p className="text-gray-500 text-sm mt-1">$126.31</p>
//         </div>
//       </div>
//     </div>
//   );
// };

// export default CryptoConverter;