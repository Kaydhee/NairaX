import spaceWarlock from '../assets/spaceWarlock.png';
import coralTribe from '../assets/coral.png';
import bakedBerserk from '../assets/bakedberserkk.png';

const Hero = () => {
	return (
		<main className='w-[80%] h-[80%] my-0 mx-auto flex items-center justify-center spaceGrotesk'>
			<section className='flex items-center justify-center w-full h-full my-[1%] mx-auto text-white'>
				<section className='basis-[45%] '>
					<h1 className='text-[3.125rem] font-bold mb-4'>What is NairaX?</h1>

					<p className='text-[1.125rem] font-medium mb-4'>
						NairaX is a decentralized exchange platform that allows users to
						trade cryptocurrencies in a secure and efficient manner.
					</p>

					<div className='flex items-center justify-start gap-6 mb-4'>
						<button>buy now</button>

						<button className='border-2 border-secondary bg-transparent'>
							explore marketplace
						</button>
					</div>

					<div className='flex items-center justify-start gap-4'>
						<h3 className='text-[2.5rem] flex flex-col'>
							4K+ <span className='text-xs mt-[-0.5rem]'>collections</span>
						</h3>
						<h3 className='text-[2.5rem] flex flex-col'>
							80K+ <span className='text-xs mt-[-0.5rem]'>market volume</span>
						</h3>
						<h3 className='text-[2.5rem] flex flex-col'>
							1M+ <span className='text-xs mt-[-0.5rem]'>art sales</span>
						</h3>
					</div>
				</section>

				<section className='flex items-center justify-center basis-[55%] h-[45vh]'>
					<div className='relative mr-[-7rem] rotate-[-15deg] '>
						<div className='absolute w-[13.0625rem] h-full bg-[#ffffffcb] filter blur-[3px] '></div>
						<img
							src={coralTribe}
							alt='coraltribe'
							className='h-[13.0625rem] w-[13.0625rem] relative p-4'
						/>
					</div>

					<div className='relative mt-[-4.5rem] z-10'>
						<div className='absolute w-[13.0625rem] h-full bg-[#ffffffcb] filter blur-[3px]'></div>
						<img
							src={spaceWarlock}
							alt='spaceWarlock'
							className='h-[13.0625rem] w-[13.0625rem] relative p-4'
						/>
					</div>

					<div className='relative ml-[-7rem] rotate-[15deg] '>
						<div className='absolute w-[13.0625rem] h-full bg-[#ffffffcb] filter blur-[3px]'></div>
						<img
							src={bakedBerserk}
							alt='bakedBerserk'
							className='h-[13.0625rem] w-[13.0625rem] relative p-4'
						/>
					</div>
				</section>
			</section>
		</main>
	);
};

export default Hero;
