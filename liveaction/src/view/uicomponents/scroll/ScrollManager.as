package view.uicomponents.scroll {
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author
	 */
	public class ScrollManager {
		
		private const ADJUST_TIME:Number = 0.25;
		private const MIN_SPEED:Number = 0.1;
		private const DISTANCE_PENALTY:Number = 0.3;
		private const MIN_MOVEMENT:Number = 10;
		
		private var itemsContainer:Sprite;
		private var maskBounds:Rectangle;
		
		private var oldPoint:Point;
		private var speed:Number;
		private var movementFraction:Number;
		
		public function ScrollManager(itemsContainer:Sprite, maskBounds:Rectangle) {
			this.itemsContainer = itemsContainer;
			this.maskBounds = maskBounds;
			
			this.itemsContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function enable():void {
			itemsContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function disable():void {
			itemsContainer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			itemsContainer.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			itemsContainer.removeEventListener(Event.ENTER_FRAME, onSlowDown);
			itemsContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function validate(distance:Number):Number {
			const MIN_LIMIT:Number = maskBounds.height - (itemsContainer.height + itemsContainer.y);
			const MAX_LIMIT:Number = -itemsContainer.y;
			
			if (distance < MIN_LIMIT || distance > MAX_LIMIT)
				distance *= DISTANCE_PENALTY;
			
			return distance;
		}
		
		private function adjustPosition():void {
			const MIN_POSITION:Number = maskBounds.height - itemsContainer.height;
			const MAX_POSITION:Number = 0;
			
			var y:Number = Math.max(itemsContainer.y, MIN_POSITION);
			y = Math.min(y, MAX_POSITION);
			
			if (itemsContainer.y < MIN_POSITION || itemsContainer.y > MAX_POSITION) {
				TweenLite.to(itemsContainer, ADJUST_TIME, { y:y } );
				itemsContainer.removeEventListener(Event.ENTER_FRAME, onSlowDown);
			}
			
		}
		
		private function onMouseDown(event:MouseEvent):void {
			if (!itemsContainer.stage) return;
			
			itemsContainer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			itemsContainer.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			itemsContainer.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			movementFraction = 0;
			oldPoint = itemsContainer.parent.globalToLocal(new Point(event.stageX, event.stageY));
		}
		
		private function onEnterFrame(event:Event):void {
			if (!itemsContainer.stage) return;
			
			const GLOBAL_POINT:Point = new Point(itemsContainer.stage.mouseX, itemsContainer.stage.mouseY);
			const CURRENT_POINT:Point = itemsContainer.parent.globalToLocal(GLOBAL_POINT);
			const DISTANCE:Number = CURRENT_POINT.y - oldPoint.y;
			
			speed = validate(DISTANCE);
			itemsContainer.y += speed;
			oldPoint = CURRENT_POINT;
		}
		
		private function onMouseUp(event:MouseEvent):void {
			if (!itemsContainer.stage) return;
			
			itemsContainer.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			itemsContainer.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			itemsContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			itemsContainer.addEventListener(Event.ENTER_FRAME, onSlowDown);
			
			adjustPosition();
		}
		
		private function onSlowDown(event:Event):void {
			speed *= 0.75;
			itemsContainer.y += validate(speed);
			adjustPosition();
			
			if (Math.abs(speed) <= MIN_SPEED) {
				itemsContainer.removeEventListener(Event.ENTER_FRAME, onSlowDown);
			}
		}
	}

}