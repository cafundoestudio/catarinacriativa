package view.screens {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import model.event.ApplicationEvent;
	import model.vo.ContainerVO;
	import model.vo.PopupVO;
	import view.AContainer;
	
	public class Popup extends AContainer {
			
		private var transitions:Dictionary;
		
		public function Popup() {
			super();
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
				addChild(containerSprite);
			}
			
		}
		
		private function onContainerClick(event:MouseEvent):void {
			//dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE_POPUP, true, false, { target:(event.target as Sprite).name } ));
		}
		
	}

}