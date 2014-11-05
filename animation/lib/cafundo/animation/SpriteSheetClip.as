package cafundo.animation {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author
	 */
	public class SpriteSheetClip extends Bitmap {
		
		private const TO_MILISECONDS:Number = 1000;
		
		private var _fps:Number;
		private var _loop:Boolean = false;
		private var _running:Boolean = false;
		private var _delay:Number = 0;
		
		private var currentFrame:int;
		private var frames:Vector.<Bitmap>;
		
		private var timer:Timer;
		
		public function SpriteSheetClip(frames:Vector.<Bitmap>, fps:Number = 12) {
			super();
			_fps = fps;
			
			this.currentFrame = 0;
			this.frames = frames;
			
			bitmapData = frames[currentFrame].bitmapData;
			smoothing = true;
			
			initTimer();
		}
		
		private function initTimer():void {
			const DELAY:Number = 1 / _fps;
			
			if (timer) {
				timer.removeEventListener(TimerEvent.TIMER, onTimer);
				timer = null;
			}
			
			timer = new Timer(DELAY * TO_MILISECONDS);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		private function updateFrame():void {
			currentFrame++;
			bitmapData = frames[currentFrame].bitmapData;
			smoothing = true;
			
			checkRange();
		}
		
		public function nextFrame():void {
			if (currentFrame < frames.length - 1) {
				currentFrame++;
				bitmapData = frames[currentFrame].bitmapData;
				smoothing = true;
			}
		}
		
		public function previousFrame():void {
			if (currentFrame > 0) {
				currentFrame--;
				bitmapData = frames[currentFrame].bitmapData;
				smoothing = true;
			}
		}
		
		private function checkRange():void {
			const LAST_FRAME:Boolean = currentFrame == frames.length - 1;
			
			if (LAST_FRAME) {
				manageLoop();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function manageLoop():void {
			if (_loop) {
				timer.stop();
				currentFrame = 0;
				setTimeout(timer.start, _delay);
			} else {
				timer.stop();
			}
		}
		
		public function play():void {
			timer.start();
			_running = true;
		}
		
		public function pause():void {
			timer.stop();
			_running = false;
		}
		
		public function stop():void {
			pause();
			reset();
		}
		
		public function reset():void {
			currentFrame = 0;
			bitmapData = frames[currentFrame].bitmapData;
		}
		
		private function onTimer(event:Event):void {
			updateFrame();
		}
		
		// GETTER AND SETTER
		
		public function get numFrames():int {
			return frames.length;
		}
		
		public function getFrame(index:uint):Bitmap {
			if (index >= frames.length)
				throw new RangeError("Invalid frame index");
			
			return frames[index];
		}
		
		public function get fps():Number {
			return _fps.valueOf();
		}
		
		public function set fps(value:Number):void {
			_fps = value;
			initTimer();
			
			if (_running)
				timer.start();
		}
		
		public function get delay():Number {
			return _delay;
		}
		
		public function set delay(value:Number):void {
			_delay = value * 1000;
		}
		
		public function get loop():Boolean {
			return _loop.valueOf();
		}
		
		public function set loop(value:Boolean):void {
			_loop = value;
		}
		
		public function get running():Boolean {
			return _running.valueOf();
		}
	
	}

}