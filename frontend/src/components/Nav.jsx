import logo from '../assets/logo.png';
import balance from '../assets/balance_icon.png';

import { useState } from 'react';

import { IoMdClose } from 'react-icons/io';
import { MdArrowDropDown } from 'react-icons/md';
import { HiOutlineMenuAlt1 } from 'react-icons/hi';

import Button from './Button';
import PropTypes from 'prop-types';

const Nav = ({ account, connectWallet }) => {
	const [showMenu, setShowMenu] = useState(false);
	const [isExpanded, setIsExpanded] = useState(false);

	const handleShowMenu = () => {
		setShowMenu(!showMenu);
		setIsExpanded(!isExpanded);
	};

	return (
		<nav className='border-b-2 w-full mx-0 py-4 px-0 bg-primary spaceGrotesk'>
			<div className='flex items-center justify-between mx-auto w-[90%] sm:w-[80%]'>
				<div className='flex items-center justify-center gap-2 sm:gap-4 text-white'>
					<img
						src={logo}
						alt='logo'
					/>

					<h2 className='font-bold text-xl sm:text-3xl'>NairaX</h2>
				</div>

				<div className='flex items-center justify-center gap-4'>
					<input
						type='text'
						placeholder='Search...'
						className='hidden sm:block bg-variantColor3 text-white pt-4 pr-8 pb-4 pl-4 placeholder:text-placeholderColor'
					/>

					<ul className='hidden sm:flex items-center justify-center gap-4'>
						<li className='flex items-center justify-center text-white cursor-pointer'>
							explore <MdArrowDropDown />
						</li>
						<li className='flex items-center justify-center text-white cursor-pointer'>
							create <MdArrowDropDown />
						</li>
						<li className='flex items-center justify-center text-white cursor-pointer'>
							profile <MdArrowDropDown />
						</li>
					</ul>
				</div>

				<div className='flex items-center justify-center'>
					<Button className=''>
						<img
							src={balance}
							alt=' custom icon'
						/>

						{account ? (
							<span>
								{account.slice(0, 6)}...{account.slice(-4)}
							</span>
						) : (
							<span onClick={connectWallet}>Connect Wallet</span>
						)}
					</Button>

					<button
						onClick={handleShowMenu}
						className='hidden'>
						{isExpanded ? <IoMdClose /> : <HiOutlineMenuAlt1 />}
					</button>
				</div>
			</div>
		</nav>
	);
};
Nav.propTypes = {
	account: PropTypes.string,
	connectWallet: PropTypes.func.isRequired,
};

export default Nav;
