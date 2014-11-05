package cafundo.touchScroll.managers.touch {
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author
	 */
	public interface ITouchManager {
		
		function setSensitivity(value:Number):void;
		function setOldPosition(value:Point):void;
		function moveReachSensitivity(newPosition:Point):Boolean;
	}

}