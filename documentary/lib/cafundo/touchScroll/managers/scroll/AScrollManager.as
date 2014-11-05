package cafundo.touchScroll.managers.scroll {
	import cafundo.touchScroll.events.TouchItemEvent;
	import cafundo.touchScroll.TouchItem;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author
	 */
	public class AScrollManager extends EventDispatcher {
		
		public static const UPDATE:String = "update";
		
		protected var itemContainer:Sprite;
		protected var localBounds:Rectangle;
		protected var globalBounds:Rectangle;
		
		protected var oldTime:Number;
		
		protected var speed:Number;
		protected var friction:Number = .85;
		
		protected var gap:Number = 50;
		protected var margin:Number = 0;
		
		protected var touchSensitivity:Number = 20;
		
		public function AScrollManager() {
			super();
		}
		
		public function setLocalBounds(bounds:Rectangle):void {
			this.localBounds = bounds;
		}
		
		public function setGlobalBounds(bounds:Rectangle):void {
			this.globalBounds = bounds;
		}
		
		public function attach(itemContainer:Sprite):void {
			this.itemContainer = itemContainer;
			this.itemContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			applyElasticity();
		}
		
		public function dettach():void {
			itemContainer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			itemContainer = null;
		}
		
		public function setFriction(value:Number):void {
			friction = value;
		}
		
		public function setItemGap(value:Number):void {
			gap = value;
			updateGap();
		}
		
		public function setMargin(value:Number):void {
			margin = value;
			applyElasticity();
		}
		
		public function add(item:DisplayObject):void {
			item.addEventListener(TouchItemEvent.ITEM_PRESSED, dispatchTouchItemEvent);
			item.addEventListener(TouchItemEvent.ITEM_RELEASED, dispatchTouchItemEvent);
			item.addEventListener(TouchItemEvent.CANCEL_PRESS, dispatchTouchItemEvent);
			
			itemContainer.addChild(item);
			updateMask();
		}
		
		private function dispatchTouchItemEvent(event:TouchItemEvent):void {
			dispatchEvent(event.clone());
		}
		
		protected function onMouseDown(event:MouseEvent):void {
			itemContainer.removeEventListener(Event.ENTER_FRAME, slowDown);
			itemContainer.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			itemContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			TweenLite.killTweensOf(itemContainer);
		}
		
		protected function onMouseUp(event:MouseEvent):void {
			itemContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			itemContainer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			itemContainer.addEventListener(Event.ENTER_FRAME, slowDown);
		}
		
		protected function slowDown(event:Event):void {
			speed *= friction;
			
			if (speed == 0) {
				itemContainer.removeEventListener(Event.ENTER_FRAME, slowDown);
			}
			
			applyElasticity();
		}
		
		protected function updateMask():void {
			dispatchEvent(new Event(UPDATE));
		}
		
		public function setTouchSensitivity(value:Number):void {
			var item:TouchItem;
			touchSensitivity = value;
			
			for (var index:int = 0; index < itemContainer.numChildren; index++) {
				item = itemContainer.getChildAt(index) as TouchItem;
				item.setSensitivity(value);
			}
		}
		
		//ABSTRACT METHODS
		
		protected function onEnterFrame(event:Event):void {
			throw new Error("Called 'onEnterFrame' from abstract class.");
		}
		
		protected function applyElasticity():void {
			throw new Error("Called 'applyElasticity' from abstract class.");
		}
		
		protected function updateGap():void {
			throw new Error("Called 'updateGap' from abstract class.");
		}
		
		public function centralizeItems():void {
			throw new Error("Called 'centralizeItems' from abstract class.");
		}
	}

}