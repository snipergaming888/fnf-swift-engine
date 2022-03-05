package components
{
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle (andre.michelle@gmail.com)
	 */
	public class MP3Pitch 
	{
		private const BLOCK_SIZE: int = 3072;
		
		private var _mp3: Sound;
		private var _sound: Sound;
		
		private var _target: ByteArray;
		
		private var _position: Number;
		private var _rate: Number;
		
		public function MP3Pitch( url: String )
		{
			_target = new ByteArray();

			_mp3 = new Sound();
			_mp3.addEventListener( Event.COMPLETE, complete );
			_mp3.load( new URLRequest( url ) );

			_position = 0.0;
			_rate = 1.0;

			_sound = new Sound();
			_sound.addEventListener( SampleDataEvent.SAMPLE_DATA, sampleData );
		}

		public function get rate(): Number
		{
			return _rate;
		}
		
		public function set rate( value: Number ): void
		{
			if( value < 0.0 )
				value = 0;

			_rate = value;
		}

		private function complete( event: Event ): void
		{
			_sound.play();
		}

		private function sampleData( event: SampleDataEvent ): void
		{
			//-- REUSE INSTEAD OF RECREATION
			_target.position = 0;
			
			//-- SHORTCUT
			var data: ByteArray = event.data;
			
			var scaledBlockSize: Number = BLOCK_SIZE * _rate;
			var positionInt: int = _position;
			var alpha: Number = _position - positionInt;

			var positionTargetNum: Number = alpha;
			var positionTargetInt: int = -1;

			//-- COMPUTE NUMBER OF SAMPLES NEED TO PROCESS BLOCK (+2 FOR INTERPOLATION)
			var need: int = Math.ceil( scaledBlockSize ) + 2;
			
			//-- EXTRACT SAMPLES
			var read: int = _mp3.extract( _target, need, positionInt );

			var n: int = read == need ? BLOCK_SIZE : read / _rate;

			var l0: Number;
			var r0: Number;
			var l1: Number;
			var r1: Number;

			for( var i: int = 0 ; i < n ; ++i )
			{
				//-- AVOID READING EQUAL SAMPLES, IF RATE < 1.0
				if( int( positionTargetNum ) != positionTargetInt )
				{
					positionTargetInt = positionTargetNum;
					
					//-- SET TARGET READ POSITION
					_target.position = positionTargetInt << 3;
	
					//-- READ TWO STEREO SAMPLES FOR LINEAR INTERPOLATION
					l0 = _target.readFloat();
					r0 = _target.readFloat();

					l1 = _target.readFloat();
					r1 = _target.readFloat();
				}
				
				//-- WRITE INTERPOLATED AMPLITUDES INTO STREAM
				data.writeFloat( l0 + alpha * ( l1 - l0 ) );
				data.writeFloat( r0 + alpha * ( r1 - r0 ) );
				
				//-- INCREASE TARGET POSITION
				positionTargetNum += _rate;
				
				//-- INCREASE FRACTION AND CLAMP BETWEEN 0 AND 1
				alpha += _rate;
				while( alpha >= 1.0 ) --alpha;
			}
			
			//-- FILL REST OF STREAM WITH ZEROs
			if( i < BLOCK_SIZE )
			{
				while( i < BLOCK_SIZE )
				{
					data.writeFloat( 0.0 );
					data.writeFloat( 0.0 );
					
					++i;
				}
			}

			//-- INCREASE SOUND POSITION
			_position += scaledBlockSize;
		}
	}
}
