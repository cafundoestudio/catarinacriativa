package cafundo.touchScroll {
	import cafundo.touchScroll.events.TouchItemEvent;
	import cafundo.touchScroll.managers.scroll.AScrollManager;
	import com.greensock.BlitMask;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author
	 */
	public class TouchScroller extends Sprite {
		
		private var background:DisplayObject;
		private var itemContainer:Sprite;
		
		private var blitMask:BlitMask;
		private var scrollerManager:AScrollManager;
		
		public function TouchScroller(scrollerManager:AScrollManager) {
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			blitMask = new BlitMask(this);
			blitMask.bitmapMode = false;
			
			itemContainer = new Sprite();
			itemContainer.x = blitMask.x;
			itemContainer.y = blitMask.y;
			
			this.scrollerManager = scrollerManager;
		}
		
		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addChild(itemContainer);
			
			setupManager();
		}
		
		private function setupManager():void {
			scrollerManager.addEventListener(AScrollManager.UPDATE, onUpdateMask);
			scrollerManager.setLocalBounds(blitMask.getBounds(this));
			scrollerManager.setGlobalBounds(blitMask.getBounds(stage));
			scrollerManager.attach(itemContainer);
			
			scrollerManager.addEventListener(TouchItemEvent.ITEM_PRESSED, dispatchTouchItemEvent);
			scrollerManager.addEventListener(TouchItemEvent.ITEM_RELEASED, dispatchTouchItemEvent);
			scrollerManager.addEventListener(TouchItemEvent.CANCEL_PRESS, dispatchTouchItemEvent);
		}
		
		private function onUpdateMask(event:Event):void {
			blitMask.update();
		}
		
		public function add(item:DisplayObject):void {
			scrollerManager.add(item);
		}
		
		private function dispatchTouchItemEvent(event:TouchItemEvent):void {
			dispatchEvent(event.clone());
		}
		
		public function setBackground(object:DisplayObject):void {
			if (background)
				removeChild(background);
			
			background = object;
			addChildAt(background, 0);
			
			blitMask.update();
		}
		
		public function setItemGap(value:Number):void {
			scrollerManager.setItemGap(value);
		}
		
		public function setFriction(value:Number):void {
			scrollerManager.setFriction(value);
		}
		
		public function centralizeItems():void {
			scrollerManager.centralizeItems();
		}
		
		private function updateBounds(width:Number, height:Number):void {
			blitMask.dispose();
			blitMask = new BlitMask(this, x, y, width, height);
			blitMask.bitmapMode = false;
			
			scrollerManager.setLocalBounds(blitMask.getBounds(this));
		}
		
		public function get maskWidth():Number {
			return blitMask.width; 
		}
		
		public function set maskWidth(value:Number):void {
			updateBounds(value, blitMask.height);
		}
		
		public function get maskHeight():Number {
			return blitMask.height;
		}
		
		public function set maskHeight(value:Number):void {
			updateBounds(blitMask.width, value);
		}
		
		public function get containerWidth():Number {
			return itemContainer.width
		}
		
		public function get containerHeight():Number {
			return itemContainer.height;
		}
		
		public function get containerX():Number {
			return itemContainer.x;
		}
		
		public function set containerX(value:Number):void {
			itemContainer.x = value;
		}
		
		public function get containerY():Number {
			return itemContainer.y;
		}
		
		public function set containerY(value:Number):void {
			itemContainer.y = value;
		}
		
		public function get itemCount():int {
			return itemContainer.numChildren;
		}
		
		public function setMargin(value:Number):void {
			scrollerManager.setMargin(value);
		}
		
		public function getItemAt(index:int):DisplayObject {
			return itemContainer.getChildAt(index);
		}
		
		public function getItemIndex(item:DisplayObject):int {
			return itemContainer.getChildIndex(item);
		}
		
		private function updateGlobalBounds():void {
			if (stage)
				scrollerManager.setGlobalBounds( blitMask.getBounds(stage) );
		}
		
		override public function set x(value:Number):void {
			super.x = value;
			
			blitMask.x = value;
			blitMask.update();
			
			updateGlobalBounds();
		}
		
		override public function set y(value:Number):void {
			super.y = value;
			
			blitMask.y = value;
			blitMask.update();
			
			updateGlobalBounds();
		}
	}

}