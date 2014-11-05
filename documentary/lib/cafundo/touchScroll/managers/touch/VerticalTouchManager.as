package cafundo.touchScroll.managers.touch {
	import cafundo.touchScroll.TouchItem;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author
	 */
	public class VerticalTouchManager implements ITouchManager {
		
		private var sensitivity:Number;
		private var oldY:Number;
		
		public function VerticalTouchManager(sensitivity:Number) {
			this.sensitivity = sensitivity;
		}
		
		public function setSensitivity(value:Number):void {
			sensitivity = value;
		}
		
		public function setOldPosition(value:Point):void {
			oldY = value.y;
		}
		
		public function moveReachSensitivity(newPosition:Point):Boolean {
			const DESLOCATION:Number = (newPosition.y - oldY);
			return DESLOCATION > sensitivity || DESLOCATION < -sensitivity;
		}
	
	}

}