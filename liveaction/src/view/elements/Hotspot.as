package view.elements 
{
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import model.event.ApplicationEvent;
	import model.vo.ContainerVO;
	import model.vo.HotspotVO;
	import view.AContainer;
	
	public class Hotspot extends AContainer
	{
		
		private var eventType:String;
		private var target:String;
		private var episode:String;
		
		public function Hotspot(hotspotVO:HotspotVO) {
			super();
			
			x = hotspotVO.x;
			y = hotspotVO.y;
			
			graphics.beginFill(0xf73dbf, 0);
			graphics.drawRect(0, 0, hotspotVO.width, hotspotVO.height);
			graphics.endFill();
			
			if (hotspotVO.background) {
				trace(this, "HAVE BACKGROUND");
				hotspotVO.background.width = hotspotVO.width;
				hotspotVO.background.height = hotspotVO.height;
				addChild(hotspotVO.background);
			}
			
			eventType = hotspotVO.event;
			target = hotspotVO.target;
			episode = hotspotVO.episode;
			createContainers(hotspotVO.containers);
		}
		
		private function createContainers(containers:Vector.<ContainerVO>):void {
			for each(var container:ContainerVO in containers) {
				addChild(createContainer(container));
			}
		}
		
		public function getEventType():String {
			return eventType.valueOf();
		}
		
		public function getTarget():String {
			return target.valueOf();
		}
		
		public function enableClick():void {
			addEventListener(MouseEvent.CLICK, onClicked);
		}
		
		public function disableClick():void {
			removeEventListener(MouseEvent.CLICK, onClicked);
		}
		
		private function onClicked(event:MouseEvent):void {
			trace(this, eventType, target);
			dispatchEvent(new ApplicationEvent(eventType, true, false, { target:this.target, episode:this.episode } ));
			
		}
		
	}

}