package cafundo.touchScroll.managers.scroll {
	import cafundo.touchScroll.managers.touch.VerticalTouchManager;
	import cafundo.touchScroll.TouchItem;
	import com.greensock.easing.Strong;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author
	 */
	public class CircularScrollManager extends AScrollManager {
		
		private const ANGLE_LIMIT:Number = 180;
		
		private var oldY:Number;
		
		private var center:Point;
		private var xRadius:Number;
		private var yRadius:Number;
		
		public function CircularScrollManager(globalCenter:Point, xRadius:Number, yRadius:Number) {
			super();
			
			this.center = globalCenter;
			this.xRadius = xRadius;
			this.yRadius = yRadius;
		}
		
		override public function attach(itemContainer:Sprite):void {
			this.itemContainer = itemContainer;
			itemContainer.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			applyElasticity();
		}
		
		override public function dettach():void {
			itemContainer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			itemContainer = null;
		}
		
		override public function add(item:DisplayObject):void {
			const TOUCH_ITEM:TouchItem = new TouchItem(item, new VerticalTouchManager(touchSensitivity));
			TOUCH_ITEM.y = itemContainer.height;
			
			if (itemContainer.numChildren > 0) 
				TOUCH_ITEM.y += gap;
			
			setXPosition(TOUCH_ITEM);
			super.add(TOUCH_ITEM);
		}
		
		private function setXPosition(item:DisplayObject):void {
			const GLOBAL_CENTER:Point = new Point(globalBounds.left + center.x, globalBounds.top + center.y);
			const GLOBAL_POSITION:Point = itemContainer.localToGlobal(new Point(item.x, item.y));
			const GLOBAL_Y:Number = GLOBAL_POSITION.y + (item.height / 2);
			
			const SIN:Number = (GLOBAL_Y - GLOBAL_CENTER.y) / yRadius;
			const ANGLE:Number = Math.asin(SIN);
			const COS:Number = Math.cos(Math.PI - ANGLE);
			
			GLOBAL_POSITION.x = (GLOBAL_CENTER.x + (xRadius * COS) ) - (item.width / 2);
			const LOCAL_POSITION:Point = itemContainer.globalToLocal(GLOBAL_POSITION);
			
			item.x = LOCAL_POSITION.x;
		}
		
		private function applyAngleLimit(value:Number):Number {
			if (value < -ANGLE_LIMIT) value = -ANGLE_LIMIT;
			if (value > ANGLE_LIMIT) value = ANGLE_LIMIT;
			
			return value;
		}
		
		private function updateItemsPosition():void {
			var item:DisplayObject;
			
			for (var index:int = 0; index < itemContainer.numChildren; index++) {
				item = itemContainer.getChildAt(index);
				setXPosition(item);
			}
		}
		
		override protected function onMouseDown(event:MouseEvent):void {
			if (!globalBounds.contains(event.stageX, event.stageY))
				return;
			
			itemContainer.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			itemContainer.removeEventListener(Event.ENTER_FRAME, slowDown);
			itemContainer.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			itemContainer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			TweenLite.killTweensOf(itemContainer);
			oldY = itemContainer.stage.mouseY;
		}
		
		override protected function onEnterFrame(event:Event):void {
			const CURRENT_Y:Number = itemContainer.stage.mouseY;
			const DELTA_Y:Number = CURRENT_Y - oldY;
			
			if (DELTA_Y == 0) return;
			
			if ( underTop() || aboveBottom()) {
				itemContainer.y += DELTA_Y * 0.3;
			} else {
				itemContainer.y += DELTA_Y;
			}
			
			oldY = CURRENT_Y;
			updateItemsPosition();
		}
		
		override protected function applyElasticity():void {
			var y:Number;
			
			const SMALL_CONTAINER:Boolean = itemContainer.height < (localBounds.height - (2 * margin));
			const IN_BOUNDS:Boolean = !underTop() && !aboveBottom();
			
			if (IN_BOUNDS ) return;
			
			if (underTop() || SMALL_CONTAINER) {
				y = localBounds.top + margin;
			} else if (aboveBottom()) {
				y = localBounds.bottom - (itemContainer.height + margin);
			}
			
			const VARS:Object = {
					y:y,
					ease:Strong.easeOut,
					onUpdate:updateItemsPosition
				}
			
			TweenLite.to(itemContainer, 0.5, VARS);
			itemContainer.removeEventListener(Event.ENTER_FRAME, slowDown);
		}
		
		private function underTop():Boolean {
			return itemContainer.y >= localBounds.top + margin
		}
		
		private function aboveBottom():Boolean {
			return itemContainer.y + itemContainer.height <= localBounds.bottom - margin;
		}
		
		override protected function slowDown(event:Event):void {
			itemContainer.y += speed;
			
			updateItemsPosition();
			super.slowDown(event);
		}
		
		override protected function onMouseUp(event:MouseEvent):void {
			super.onMouseUp(event);
			itemContainer.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			speed = itemContainer.stage.mouseY - oldY;
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
			updateItemsPosition();
			updateMask();
		}
		
		override public function setGlobalBounds(bounds:Rectangle):void {
			super.setGlobalBounds(bounds);
			
			if (itemContainer)
				updateItemsPosition();
		}
		
		override public function centralizeItems():void {
			throw new Error("Cannot centralize items of a circular list");
		}
	}

}