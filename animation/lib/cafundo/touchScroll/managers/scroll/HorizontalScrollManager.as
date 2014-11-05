package cafundo.touchScroll.managers.scroll {
	import cafundo.touchScroll.managers.touch.HorizontalTouchManager;
	import cafundo.touchScroll.TouchItem;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author
	 */
	public class HorizontalScrollManager extends AScrollManager {
		
		private var oldX:Number;
		
		public function HorizontalScrollManager() {
			super();
		}
		
		override protected function onMouseDown(event:MouseEvent):void {
			super.onMouseDown(event);
			oldX = itemContainer.stage.mouseX;
		}
		
		override protected function onEnterFrame(event:Event):void {
			const MOUSE_X:Number = itemContainer.stage.mouseX;
			const DELTA_X:Number = MOUSE_X - oldX;
			
			oldX = MOUSE_X;
			oldTime = getTimer();
			
			if (itemContainer.x >= localBounds.left || (itemContainer.x + itemContainer.width) <= localBounds.right) {
				itemContainer.x += DELTA_X * 0.3;
			} else {
				itemContainer.x += DELTA_X;
			}
		}
		
		override protected function onMouseUp(event:MouseEvent):void {
			super.onMouseUp(event);
			speed = itemContainer.stage.mouseX - oldX;
		}
		
		override protected function slowDown(event:Event):void {
			itemContainer.x += speed;
			super.slowDown(event);
		}
		
		override protected function applyElasticity():void {
			var x:Number;
			
			const SMALL_CONTAINER:Boolean = itemContainer.width < localBounds.width;
			const PASSED_LEFT:Boolean = itemContainer.x >= localBounds.left;
			const PASSED_RIGHT:Boolean = itemContainer.x + itemContainer.width <= localBounds.right;
			const IN_BOUNDS:Boolean = !PASSED_LEFT && !PASSED_RIGHT;
			
			if (IN_BOUNDS ) return;
			
			if (PASSED_LEFT || SMALL_CONTAINER) {
				x = localBounds.left + margin;
			} else if (PASSED_RIGHT) {
				x = localBounds.right - (itemContainer.width + margin);
			}
			
			const VARS:Object = {
					x:x,
					ease:Strong.easeOut
				}
			
			TweenLite.to(itemContainer, 0.5, VARS)
			itemContainer.removeEventListener(Event.ENTER_FRAME, slowDown);
		}
		
		override protected function updateGap():void {
			var child:DisplayObject;
			var width:Number = itemContainer.getChildAt(0).width;
			
			for (var index:int = 1; index < itemContainer.numChildren; index++) {
				child = itemContainer.getChildAt(index);
				child.x = width + gap;
				
				width += gap + child.width;
			}
			
			itemContainer.width = width;
			updateMask();
		}
		
		override public function add(item:DisplayObject):void {
			const TOUCH_ITEM:TouchItem = new TouchItem(item, new HorizontalTouchManager(touchSensitivity));
			TOUCH_ITEM.x = itemContainer.width;
			
			if (itemContainer.numChildren > 0) 
				TOUCH_ITEM.x += gap;
			
			super.add(TOUCH_ITEM);
		}
		
		override public function centralizeItems():void {
			var child:DisplayObject;
			
			for (var index:int = 0; index < itemContainer.numChildren; index++) {
				child = itemContainer.getChildAt(index);
				child.y = (itemContainer.height - child.height) / 2;
			}
		}
	
	}

}