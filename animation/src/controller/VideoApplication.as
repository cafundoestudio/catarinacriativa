package controller {
	import com.freshplanet.ane.AirAACPlayer.AirAACPlayer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.text.TextField;
	
	public class VideoApplication extends Sprite {
		
		public function VideoApplication() {
			
			var text:TextField = new TextField();
			text.text = "Preparing";
			addChild(text);
			
			var video:AirAACPlayer = new AirAACPlayer();
			video.addEventListener(AirAACPlayer.AAC_PLAYER_PREPARED, onPlayerPrepared);
			video.loadUrl("http://cafundo.tv/download/39360725.mp4");
			
			text.text = "Waiting";
		
			// Once the player is ready, you can start playing
			var onPlayerPrepared:Function = function(event:Event):void {
				text.text = "Ready";
				video.play();
			};
			
		}
		
	}

}