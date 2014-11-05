package cafundo.touchScroll.events {
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author
	 */
	public class TouchItemEvent extends Event {
		
		public static const ITEM_PRESSED:String = "itemPressed";
		public static const ITEM_RELEASED:String = "itemReleased";
		
		public static const CANCEL_PRESS:String = "cancelPress";
		
		private var data:DisplayObject;
		
		public function TouchItemEvent(type:String, data:DisplayObject, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
		override public function clone():Event {
			return new TouchItemEvent(type, data, bubbles, cancelable);
		}
		
		public function get item():DisplayObject {
			return data;
		}
	
	}

}