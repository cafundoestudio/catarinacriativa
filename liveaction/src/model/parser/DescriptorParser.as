package model.parser 
{
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.LoaderMax;
	import flash.display.Bitmap;
	import model.event.ApplicationEvent;
	import model.vo.AppVO;
	import model.vo.ContainerVO;
	import model.vo.EventVO;
	import model.vo.HotspotVO;
	import model.vo.ImageVO;
	import model.vo.PopupVO;
	import model.vo.ScreenVO;
	import model.vo.ScrollListVO;
	import model.vo.TextVO;
	public class DescriptorParser 
	{
		
		private static var _scaleX:Number = 1;
		private static var _scaleY:Number = 1;
		
		public function DescriptorParser() {
		}
		
		public static function setScaleFactors(scaleX:Number, scaleY:Number):void {
			_scaleX = scaleX;
			_scaleY = scaleY;
		}
		
		public static function parseApp(xml:XML):AppVO {
			
			const APP_VO:AppVO = new AppVO();
			//APP_VO.actionbar = parseContainer(XML(xml.actionbar));
			APP_VO.actionbar = parseStates(XML(xml.actionbar));
			APP_VO.screenContainer = parseContainer(XML(xml.screenContainer));
			APP_VO.popupContainer = parseContainer(XML(xml.popupContainer));
			APP_VO.menu = parseContainer(XML(xml.menu));
			
			return APP_VO;
			
		}
		
		public static function parseStates(xml:XML):ContainerVO {
			const ACTION_BAR:ContainerVO = parseContainer(xml);
			const STATES:Vector.<ContainerVO> = new Vector.<ContainerVO>();
			
			for each (var state:XML in xml.states.state) {
				STATES.push(parseContainer(state));
			}
			
			ACTION_BAR.states = STATES;
			return ACTION_BAR;
		}
		
		public static function parseScreen(xml:XML):ScreenVO {
			const SCREEN:XML = XML(xml.screen);
			const SCREEN_VO:ScreenVO = new ScreenVO();
			SCREEN_VO.events = new Vector.<EventVO>();
			
			SCREEN_VO.name = SCREEN.@name;
			SCREEN_VO.x = SCREEN.@x * _scaleX;
			SCREEN_VO.y = SCREEN.@y * _scaleY;
			SCREEN_VO.width = SCREEN.@width * _scaleX;
			SCREEN_VO.height = SCREEN.@height * _scaleY;
			SCREEN_VO.alpha = SCREEN.@alpha;
			SCREEN_VO.unlocked = SCREEN.unlocked;
			trace(DescriptorParser, SCREEN_VO.unlocked);
			
			SCREEN_VO.transitionIn = parseTransition(XML(SCREEN.transitions.enter));
			SCREEN_VO.transitionOut = parseTransition(XML(SCREEN.transitions.leave));
			SCREEN_VO.containers = parseContainers(XMLList(SCREEN.container));
			
			if (SCREEN.scrollList.length() > 0)
			SCREEN_VO.scrollList = parseScrollList(XML(SCREEN.scrollList));
			
			var eventVO:EventVO;
			for each (var event:XML in SCREEN.event) {
				eventVO = new EventVO;
				eventVO.type = event.@type;
				eventVO.data = event.@data;
				SCREEN_VO.events.push(eventVO);
			}
			
			return SCREEN_VO;
		}
		
		public static function parsePopup(xml:XML):PopupVO {
			
			const POPUP_VO:PopupVO = new PopupVO();
			
			if (xml.popup.length() > 0) {
				
				POPUP_VO.containers = parseContainers(XMLList(xml.popup.container));
				
			}
			
			return POPUP_VO;
		}
		
		private static function parseContainers(list:XMLList):Vector.<ContainerVO> {
			
			var containers:Vector.<ContainerVO> = new Vector.<ContainerVO>();
			
			if (list.length() > 0) {
				
				var containerVO:ContainerVO;
				
				for each(var container:XML in list) {
					
					containerVO = parseContainer(container);
					containers.push(containerVO);
					
				}
				
			}
			
			return containers
			
		}
		
		private static function parseContainer(xml:XML):ContainerVO {
			
			const CONTAINER_VO:ContainerVO = new ContainerVO();
			CONTAINER_VO.name = xml.@name;
			CONTAINER_VO.x = xml.@x * _scaleX;
			CONTAINER_VO.y = xml.@y * _scaleY;
			CONTAINER_VO.width = xml.@width * _scaleX;
			CONTAINER_VO.height = xml.@height * _scaleY;
			CONTAINER_VO.alpha = xml.@alpha;
			
			if (xml.@openevent != "")
				CONTAINER_VO.openEvent = new ApplicationEvent(xml.@openevent, true, false, { target: xml.@opentarget } );
			if (xml.@closeevent != "")
				CONTAINER_VO.closeEvent = new ApplicationEvent(xml.@closeevent, true, false, { target: xml.@closetarget } );
				
			if (LoaderMax.getContent(xml.@background)) {
				
				CONTAINER_VO.background = ContentDisplay(LoaderMax.getContent(xml.@background)).rawContent;
				CONTAINER_VO.background.width = CONTAINER_VO.width;
				CONTAINER_VO.background.height = CONTAINER_VO.height;
				
			}
			else {
				
				CONTAINER_VO.background = null;
				
			}
			
			if (xml.@backgroundColor) {
				
				CONTAINER_VO.backgroundColor = xml.@backgroundColor;
				
			}
			
			CONTAINER_VO.containers = parseContainers(XMLList(xml.container));
			CONTAINER_VO.images = parseImage(XMLList(xml.image));
			CONTAINER_VO.texts = parseText(XMLList(xml.text));
			CONTAINER_VO.hotspots = parseHotspot(XMLList(xml.hotspot));
			
			return CONTAINER_VO;
			
		}
		
		private static function parseImage(list:XMLList):Vector.<ImageVO> {
			
			var images:Vector.<ImageVO> = new Vector.<ImageVO>();
			
			if (list.length() > 0) {
				
				var imageVO:ImageVO;
				
				for each(var image:XML in list) {
					
					imageVO = new ImageVO();
					imageVO.src = getImage(image.@src);
					imageVO.x = image.@x * _scaleX;
					imageVO.y = image.@y * _scaleY;
					imageVO.width = image.@width * _scaleX;
					imageVO.height = image.@height * _scaleY;
					
					images.push(imageVO);
					
				}
				
			}
			
			return images;
			
		}
		
		private static function getImage(src:String):Bitmap {
			if (src.length == 0) return null;
			
			const SOURCE:Bitmap = LoaderMax.getLoader(src).rawContent;
			const IMAGE:Bitmap = new Bitmap(SOURCE.bitmapData);
			IMAGE.smoothing = true;
			
			return IMAGE;
		}
		
		private static function parseText(list:XMLList):Vector.<TextVO> {
			
			var texts:Vector.<TextVO> = new Vector.<TextVO>();
			
			if (list.length() > 0) {
				
				var textVO:TextVO;
				
				for each(var text:XML in list) {
					
					textVO = new TextVO();
					textVO.value = text.@value;
					textVO.x = text.@x * _scaleX;
					textVO.y = text.@y * _scaleY;
					textVO.width = text.@width * _scaleX;
					textVO.height = text.@height * _scaleY;
					textVO.size = text.@size * _scaleX;
					textVO.color = text.@color;
					textVO.bold = (text.@bold == "true");
					
					texts.push(textVO);
					
				}
				
			}
			
			return texts;
			
		}
		
		private static function parseHotspot(list:XMLList):Vector.<HotspotVO> {
			
			var hotspots:Vector.<HotspotVO> = new Vector.<HotspotVO>();
			
			if (list.length() > 0) {
				
				var hotspotVO:HotspotVO;
				
				for each(var hotspot:XML in list) {
					
					hotspotVO = new HotspotVO();
					hotspotVO.containers = parseContainers(hotspot.container);
					hotspotVO.background = getImage(hotspot.@background);
					hotspotVO.x = Math.floor(hotspot.@x * _scaleX);
					hotspotVO.y = Math.floor(hotspot.@y * _scaleY);
					hotspotVO.width = Math.floor(hotspot.@width * _scaleX);
					hotspotVO.height = Math.floor(hotspot.@height * _scaleY);
					hotspotVO.event = hotspot.@event;
					hotspotVO.target = hotspot.@target;
					hotspotVO.episode = hotspot.@episode;

					hotspots.push(hotspotVO);
					
				}
				
			}
			
			return hotspots;
			
		}
		
		private static function parseScrollList(xml:XML):ScrollListVO {
			const VO:ScrollListVO = new ScrollListVO();
			
			VO.x = Math.floor(xml.@x * _scaleX);
			VO.y = Math.floor(xml.@y * _scaleY);
			VO.width = Math.floor(xml.@width * _scaleX);
			VO.height = Math.floor(xml.@height * _scaleY);
			VO.items = parseHotspot(xml.hotspot);
			
			return VO;
		}
		
		private static function parseTransition(descriptor:XML):Object {
			return {
				x: descriptor.@x * _scaleX,
				y: descriptor.@y * _scaleY,
				alpha: descriptor.@alpha,
				onComplete:null
			}
		}
		
	}

}