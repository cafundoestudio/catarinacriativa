package cafundo.touchScroll.managers.scroll {
	import cafundo.touchScroll.events.TouchItemEvent;
	import cafundo.touchScroll.managers.touch.VerticalTouchManager;
	import cafundo.touchScroll.TouchItem;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author
	 */
	public class VerticalScrollManager extends AScrollManager {
		
		private var oldY:Number;
		
		public function VerticalScrollManager() {
			super();
		}
		
		override protected function onMouseDown(event:MouseEvent):void {
			super.onMouseDown(event);
			oldY = itemContainer.stage.mouseY;
		}
		
		override protected function onEnterFrame(event:Event):void {
			const MOUSE_Y:Number = itemContainer.stage.mouseY;
			const DELTA_Y:Number = MOUSE_Y - oldY;
			
			oldY = MOUSE_Y;
			oldTime = getTimer();
			
			if (itemContainer.y >= localBounds.top || (itemContainer.y + itemContainer.height) <= localBounds.bottom) {
				itemContainer.y += DELTA_Y * 0.3;
			} else {
				itemContainer.y += DELTA_Y;
			}
		}
		
		override protected function onMouseUp(event:MouseEvent):void {
			super.onMouseUp(event);
			speed = itemContainer.stage.mouseY - oldY;
		}
		
		override protected function slowDown(event:Event):void {
			itemContainer.y += speed;
			super.slowDown(event);
		}
		
		override protected function applyElasticity():void {
			var y:Number;
			
			const SMALL_CONTAINER:Boolean = itemContainer.height < localBounds.height;
			const UNDER_TOP:Boolean = itemContainer.y >= localBounds.top;
			const ABOVE_BOTTOM:Boolean = itemContainer.y + itemContainer.height <= localBounds.bottom;
			const IN_BOUNDS:Boolean = !UNDER_TOP && !ABOVE_BOTTOM;
			
			if (IN_BOUNDS ) return;
			
			if (UNDER_TOP || SMALL_CONTAINER) {
				y = localBounds.top + margin;
			} else if (ABOVE_BOTTOM) {
				y = localBounds.bottom - (itemContainer.height + margin);
			}
			
			const VARS:Object = {
					y:y,
					ease:Strong.easeOut
				}
			
			TweenLite.to(itemContainer, 0.5, VARS);
			itemContainer.removeEventListener(Event.ENTER_FRAME, slowDown);
		}
		
		override protected function updateGap():void {
			var child:DisplayObject;
			var height:Number = itemContainer.getChildAt(0).height;
			
			for (var index:int = 1; index < itemContainer.numChildren; index++) {
				child = itemContainer.getChildAt(index);
				child.y = height + gap;
				
				height += gap + child.height;
			}
			
			itemContainer.height = height;
			updateMask();
		}
		
		override public function add(item:DisplayObject):void {
			const TOUCH_ITEM:TouchItem = new TouchItem(item, new VerticalTouchManager(touchSensitivity));
			TOUCH_ITEM.y = itemContainer.height;
			
			if (itemContainer.numChildren > 0) 
				TOUCH_ITEM.y += gap;
			
			super.add(TOUCH_ITEM);
		}
		
		override public function centralizeItems():void {
			var child:DisplayObject;
			
			for (var index:int = 0; index < itemContainer.numChildren; index++) {
				child = itemContainer.getChildAt(index);
				child.x = (itemContainer.width - child.width) / 2;
			}
		}
	
	}

}