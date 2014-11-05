package cafundo.touchScroll {
	import cafundo.touchScroll.events.TouchItemEvent;
	import cafundo.touchScroll.managers.touch.ITouchManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author
	 */
	public class TouchItem extends Sprite {
		
		private var delay:Number = 500;
		private var timer:Timer;
		
		private var manager:ITouchManager;
		
		public function TouchItem(data:DisplayObject, manager:ITouchManager) {
			super();
			addChild(data);
			
			timer = new Timer(delay);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			this.manager = manager;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function setSensitivity(value:Number):void {
			manager.setSensitivity(value);
		}
		
		private function onAddedToStage(event:Event):void {
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(event:MouseEvent):void {
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			const POSITION:Point = new Point(event.stageX, event.stageY);
			manager.setOldPosition(POSITION);
			
			timer.start();
		}
		
		private function onMouseMove(event:MouseEvent):void {
			const NEW_POSITION:Point = new Point(event.stageX, event.stageY);
			if (!manager.moveReachSensitivity(NEW_POSITION)) return;
			
			if (!timer.running) {
				const ITEM:DisplayObject = getChildAt(0);
				dispatchEvent(new TouchItemEvent(TouchItemEvent.CANCEL_PRESS, ITEM));
			}
			
			timer.reset();
			
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(event:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			timer.reset();
			
			const ITEM:DisplayObject = getChildAt(0);
			dispatchEvent(new TouchItemEvent(TouchItemEvent.ITEM_RELEASED, ITEM));
		}
		
		private function onTimer(event:Event):void {
			timer.reset();
			
			const ITEM:DisplayObject = getChildAt(0);
			dispatchEvent(new TouchItemEvent(TouchItemEvent.ITEM_PRESSED, ITEM));
		}
	}

}