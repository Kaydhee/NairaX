/** @type {import('tailwindcss').Config} */
export default {
	content: ['./src/**/*.{html,js,jsx,ts,tsx}', './public/**/*.html'],
	theme: {
		colors: {
			white: '#fff',
			// blue: '#0000ff',
			primary: '#001e3c',
			variantColor1: '#003162',
			variantColor2: '#002953',
			variantColor3: '#00264d',
			secondary: '#007fff',
			placeholderColor: '#00509f',

			green: '#00cb51',
			transparent: 'transparent',
		},
		extend: {
			fontFamily: {
				fonts: ['Space Grotesk'],
			},
		},
	},
	plugins: [],
};
