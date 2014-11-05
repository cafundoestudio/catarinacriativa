package controller {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import model.event.ApplicationEvent;
	import model.soundrec.InputRecorder;
	import org.bytearray.micrecorder.encoder.WaveEncoder;
	import view.AppView;
	
	/**
	 * ...
	 * @author
	 */
	public class RecordController {
		
		private const RECORD_TIME:Number = 15000;
		private const URL:String = "http://192.168.0.19";
		private const UNLOCKED:String = "_unlocked";
		
		private var appView:AppView;
		private var recorder:InputRecorder;
		
		private var popup:String;
		private var targetEpisode:String;
		
		public function RecordController(appView:AppView) {
			this.appView = appView;
			this.appView.addEventListener(ApplicationEvent.RECORD_DATA, onRecordData);
			
			recorder = new InputRecorder();
		}
		
		private function sendData(data:ByteArray):void {
			const REQUEST:URLRequest = new URLRequest(URL);
			const LOADER:URLLoader = new URLLoader();
			const ENCODER:WaveEncoder = new WaveEncoder();
			
			data.position = 0;
			
			REQUEST.method = URLRequestMethod.POST;
			REQUEST.contentType = "application/octet-stream";
			REQUEST.data = ENCODER.encode(data, 2);
			
			LOADER.addEventListener(Event.COMPLETE, onResponse);
			LOADER.addEventListener(IOErrorEvent.IO_ERROR, onError);
			LOADER.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			LOADER.load(REQUEST);
		}
		
		private function getMatchIndex(matches:Array):int {
			if (targetEpisode) {
				return matches.indexOf(targetEpisode);
			}  
			
			return matches.length - 1;
		}
		
		private function onRecordData(event:ApplicationEvent):void {
			popup = event.getData().target;
			targetEpisode = event.getData().episode;
			
			appView.removeEventListener(ApplicationEvent.RECORD_DATA, onRecordData);
			appView.openPopup(popup);
			
			recorder.startRecording();
			setTimeout(onStopRecording, RECORD_TIME);
		}
		
		private function onStopRecording():void {
			recorder.stopRecording();
			sendData(recorder.getData());
		}
		
		private function onResponse(event:Event):void {
			const LOADER:URLLoader = event.currentTarget as URLLoader;
			LOADER.removeEventListener(Event.COMPLETE, onResponse);
			LOADER.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			LOADER.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			appView.addEventListener(ApplicationEvent.RECORD_DATA, onRecordData);
			appView.closePopup(popup);
			
			const RESPONSE:Object = JSON.parse(LOADER.data);
			const MATCHES:Array = RESPONSE.matches;
			
			
			const MATCH_INDEX:int = getMatchIndex(MATCHES);
			if (MATCH_INDEX > -1) {
				appView.dispatchEvent( new ApplicationEvent( ApplicationEvent.UNLOCK_EPISODE, false, false, {target:MATCHES[MATCH_INDEX]}) );
			} else {
				appView.openPopup("noMatchPopup");
			}
			
			targetEpisode = null;
		}
		
		private function onError(event:Event):void {
			trace(this, "onError", event.toString());
			const LOADER:URLLoader = event.currentTarget as URLLoader;
			LOADER.removeEventListener(Event.COMPLETE, onResponse);
			LOADER.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			LOADER.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			appView.addEventListener(ApplicationEvent.RECORD_DATA, onRecordData);
			appView.closePopup(popup);
			appView.openPopup("noMatchPopup");
		}
	
	}

}