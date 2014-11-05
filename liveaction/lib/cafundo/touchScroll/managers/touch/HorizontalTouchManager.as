package cafundo.touchScroll.managers.touch {
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author
	 */
	public class HorizontalTouchManager implements ITouchManager {
		
		private var sensitivity:Number;
		private var oldX:Number;
		
		public function HorizontalTouchManager(sensitivity:Number) {
			this.sensitivity = sensitivity;
		}
		
		public function setSensitivity(value:Number):void {
			sensitivity = value;
		}
		
		public function setOldPosition(value:Point):void {
			oldX = value.x;
		}
		
		public function moveReachSensitivity(newPosition:Point):Boolean {
			const DESLOCATION:Number = (newPosition.x - oldX);
			return DESLOCATION > sensitivity || DESLOCATION < -sensitivity;
		}
	}

}