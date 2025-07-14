import PropTypes from 'prop-types';

const Button = ({ children }) => {
	return (
		<button className='flex items-center justify-center gap-2 cursor-pointer text-base bg-secondary border border-transparent text-white py-[0.7rem] px-4 hover:bg-transparent hover:border hover:border-secondary hover:text-secondary transition'>
			{children}
		</button>
	);
};

Button.propTypes = {
	children: PropTypes.node.isRequired,
};

export default Button;
