package 
{
	import controller.Application;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import model.event.ApplicationEvent;
	
	public class Main extends Sprite 
	{
		
		[Embed(source="../bin/assets/misc/splash.png")]
		private const SPLASH:Class;
		
		private var splashBitmap:Bitmap;
		private var debug:TextField;
			
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			showSplashScreen();
			
			// entry point
			const APP:Application = new Application(stage);
			APP.addEventListener(ApplicationEvent.READY, onApplicationReady);
			
		}
		
		private function onApplicationReady(event:ApplicationEvent):void {
			
			removeChild(splashBitmap);
			
		}
		
		private function showSplashScreen():void {
			
			splashBitmap = (new SPLASH() as Bitmap);
			splashBitmap.width = stage.fullScreenWidth;
			splashBitmap.height = stage.fullScreenHeight;
			splashBitmap.smoothing = true;
			
			addChild(splashBitmap);
			
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}