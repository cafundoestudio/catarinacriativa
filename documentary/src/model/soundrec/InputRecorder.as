package model.soundrec {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SampleDataEvent;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedMode;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import org.bytearray.micrecorder.encoder.WaveEncoder;
	
	/**
	 * ...
	 * @author
	 */
	public class InputRecorder extends EventDispatcher {
		
		private var microphone:Microphone;
		private var audioData:ByteArray;
		private var playData:ByteArray;
		
		public function InputRecorder() {
			const MIC_OPTIONS:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
			MIC_OPTIONS.mode = MicrophoneEnhancedMode.FULL_DUPLEX;
			
			microphone = Microphone.getMicrophone();
			microphone.setUseEchoSuppression(true);
			microphone.enhancedOptions = MIC_OPTIONS;
			microphone.setSilenceLevel(0);
			microphone.noiseSuppressionLevel = -20;
			microphone.gain = 60;
			microphone.rate = 44;
			
		}
		
		/**
		 * Starts the recording process.
		 */
		public function startRecording():void {
			audioData = null;
			audioData = new ByteArray();
			microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, onMicData);
		}
		
		/**
		 * Stops the recording process.
		 */
		public function stopRecording():void {
			playData = new ByteArray();
			
			microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, onMicData);
			audioData.position = 0;
			playData.length = 0;
			playData.writeBytes(audioData);
			playData.position = 0;
			audioData.length = 0;
			
		}
		
		/**
		 * Return the data recorded.
		 * 
		 * @return Returns a bytearray with the audio data.
		 */
		public function getData():ByteArray {
			return playData;
		}
		
		/**
		 * Reads and saves the sample of data recorded.
		 * 
		 * @param	event containing the data sample.
		 */
		private function onMicData(event:SampleDataEvent):void {
			while (event.data.bytesAvailable) {
				var SAMPLE:Number = event.data.readFloat();
				
				// write data twice to save in stereo mode.
				audioData.writeFloat(SAMPLE);
				audioData.writeFloat(SAMPLE);
			}
		}
	}

}