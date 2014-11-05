package model.event 
{
	import flash.events.Event;

	public class ApplicationEvent extends Event
	{
			
		public static var RECORD_DATA:String = "RECORD_DATA";
		
		public static var CHANGE_SCREEN:String = "CHANGE_SCREEN";
		public static var CHANGE_ACTION_BAR:String = "CHANGE_ACTION_BAR";
		public static var UNLOCK_EPISODE:String = "UNLOCK_EPISODE";
		
		public static var READY:String = "READY";
		public static var BACK:String = "BACK";
		public static var MENU:String = "MENU";
		public static var OPEN_POPUP:String = "OPEN_POPUP";
		public static var CLOSE_POPUP:String = "CLOSE_POPUP";
		
		private var data:Object;
		
		public function ApplicationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:Object = null) 
		{
			
			this.data = data;
			
			super(type, bubbles, cancelable);
			
		}
		
		public function getData():Object {
			
			return data;
			
		}
		
	}

}