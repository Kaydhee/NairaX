import spaceWarlock from '../assets/spaceWarlock.png';
import coralTribe from '../assets/coraltribe.png';
import bakedBerserk from '../assets/bakedberserk.png';

const Hero = () => {
	return (
		<main>
			<section>
				<section>
					<h1>What is NairaX?</h1>

					<p>
						NairaX is a decentralized exchange platform that allows users to
						trade cryptocurrencies in a secure and efficient manner.
					</p>

					<div className=''>
						<button>buy now</button>

						<button>explore marketplace</button>
					</div>

					<div className=''>
						<h3>
							4K+ <span>collections</span>
						</h3>
						<h3>
							80K+ <span>market volume</span>
						</h3>
						<h3>
							1M+ <span>art sales</span>
						</h3>
					</div>
				</section>

				<section>
					<div className=''>
						<div className=''></div>
						<img
							src={coralTribe}
							alt='coraltribe'
						/>
					</div>

					<div className=''>
						<div className=''></div>
						<img
							src={spaceWarlock}
							alt='spaceWarlock'
						/>
					</div>

					<div className=''>
						<div className=''></div>
						<img
							src={bakedBerserk}
							alt='bakedBerserk'
						/>
					</div>
				</section>
			</section>
		</main>
	);
};

export default Hero;
