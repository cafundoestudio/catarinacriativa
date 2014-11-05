package view.screens {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import model.event.ApplicationEvent;
	import model.vo.ContainerVO;
	import model.vo.PopupVO;
	import view.AContainer;
	
	public class Popup extends AContainer {
			
		private var openEvents:Dictionary;
		private var closeEvents:Dictionary;
		
		public function Popup() {
			super();
			
			openEvents = new Dictionary();
			closeEvents = new Dictionary();
		}
		
		public function setPopup(vo:PopupVO):void {
			removeChildren();
			createContainers(vo.containers);
		}
		
		private function createContainers(containers:Vector.<ContainerVO>):void {
			
			var containerSprite:Sprite;
			
			for each(var container:ContainerVO in containers) {
				containerSprite = createContainer(container);
				containerSprite.addEventListener(MouseEvent.CLICK, onContainerClick);
				
				if (container.openEvent)
					openEvents[container.name] = container.openEvent;
				if (container.closeEvent)
					closeEvents[container.name] = container.closeEvent;
					
				addChild(containerSprite);
			}
			
		}
		
		public function closeAll():void {
			var child:DisplayObject;
			
			for (var i:int = 0; i < numChildren; i++) {
				child = getChildAt(i);
				child.visible = false;
				child.alpha = 0;
			}
			
		}
		
		public function closePopup(name:String):void {
			const SPRITE:DisplayObject = getChildByName(name);
			
			if (SPRITE) {
				SPRITE.visible = false;
				SPRITE.alpha = 0;
			}
			
			if (closeEvents[name])
				dispatchEvent( new ApplicationEvent(closeEvents[name].type, true, false, {target:closeEvents[name].getData().target} ) );
		}
		
		public function openPopup(name:String):void {
			trace(this, "OPEN POPUP");
			const SPRITE:DisplayObject = getChildByName(name);
			
			if (SPRITE) {
				SPRITE.visible = true;
				SPRITE.alpha = 1;
			}
			
			if (openEvents[name]) {
				trace(this, "DISPATCH OPEN EVENT", openEvents[name]);
				dispatchEvent( new ApplicationEvent(openEvents[name].type, true, false, {target:openEvents[name].getData().target} ) );
			}
		}
		
		private function onContainerClick(event:MouseEvent):void {
			//dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE_POPUP, true, false, { target:(event.target as Sprite).name } ));
		}
		
	}

}