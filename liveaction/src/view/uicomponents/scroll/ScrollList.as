package view.uicomponents.scroll {
	import com.greensock.BlitMask;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.event.ApplicationEvent;
	import view.elements.Hotspot;
	
	/**
	 * ...
	 * @author
	 */
	public class ScrollList extends Sprite {
		
		private const MIN_DESLOCATION:Number = 5;
		
		private var blitmask:BlitMask;
		private var itemsContainer:Sprite;
		
		private var manager:ScrollManager;
		
		private var oldY:Number;
		private var deslocationFraction:Number;
		
		public function ScrollList(width:Number, height:Number) {
			super();
			
			itemsContainer = new Sprite();
			
			blitmask = new BlitMask(itemsContainer, 0, 0, width, height);
			blitmask.bitmapMode = false;
			
			manager = new ScrollManager(itemsContainer, blitmask.getBounds(blitmask));
			
			addChild(itemsContainer);
		}
		
		public function addItem(item:Sprite):void {
			item.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			itemsContainer.addChild(item);
			blitmask.update();
		}
		
		private function onMouseDown(event:MouseEvent):void {
			const ITEM:Sprite = event.currentTarget as Sprite;
			ITEM.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			ITEM.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			ITEM.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			oldY = event.stageY;
			deslocationFraction = 0;
		}
		
		private function onMouseMove(event:MouseEvent):void {
			const ITEM:Sprite = event.currentTarget as Sprite;
			const DIFF:Number = Math.abs(event.stageY - oldY);
			
			deslocationFraction += DIFF;
			oldY = event.stageY;
			
			if (deslocationFraction > MIN_DESLOCATION) {
				ITEM.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				ITEM.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				ITEM.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			const ITEM:Hotspot = event.currentTarget as Hotspot;
			ITEM.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			ITEM.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			ITEM.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			trace(this, "DISPATCH EVENT: ", ITEM.getEventType(), ITEM.getTarget());
			dispatchEvent( new ApplicationEvent( ITEM.getEventType(), true, false, {target:ITEM.getTarget()}));
		}
	}

}