package model.parser 
{
	import com.greensock.loading.display.ContentDisplay;
	import com.greensock.loading.LoaderMax;
	import flash.display.Bitmap;
	import model.vo.ContainerVO;
	import model.vo.HotspotVO;
	import model.vo.ImageVO;
	import model.vo.ScreenVO;
	import model.vo.TextVO;
	public class ScreenParser 
	{
		
		private static var _scaleX:Number = 1;
		private static var _scaleY:Number = 1;
		
		public function ScreenParser() {
		}
		
		public static function setScaleFactors(scaleX:Number, scaleY:Number):void {
			_scaleX = scaleX;
			_scaleY = scaleY;
		}
		
		public static function parse(xml:XML):ScreenVO {
			trace(ScreenParser, xml);
			
			const SCREEN_VO:ScreenVO = new ScreenVO();
			SCREEN_VO.transitionIn = parseTransition(XML(xml.transitions.enter));
			SCREEN_VO.transitionOut = parseTransition(XML(xml.transitions.leave));
			SCREEN_VO.containers = parseContainer(XMLList(xml.container));
				
			return SCREEN_VO;
		}
		
		public static function parseContainer(list:XMLList):Vector.<ContainerVO> {
			
			var containers:Vector.<ContainerVO> = new Vector.<ContainerVO>();
			
			if (list.length() > 0) {
			
				var containerVO:ContainerVO;
				
				for each(var container:XML in list) {
					
					containerVO = new ContainerVO();
					containerVO.name = container.@name;
					containerVO.x = container.@x * _scaleX;
					containerVO.y = container.@y * _scaleY;
					containerVO.width = container.@width * _scaleX;
					containerVO.height = container.@height * _scaleY;
					if (LoaderMax.getContent(container.@background)) {
						containerVO.background = ContentDisplay(LoaderMax.getContent(container.@background)).rawContent;
						containerVO.background.width = containerVO.width;
						containerVO.background.height = containerVO.height;
					}
					else {
						containerVO.background = null;
					}
					containerVO.visible = (container.@visible == "true");
					
					containerVO.containers = parseContainer(XMLList(container.container));
					containerVO.images = parseImage(XMLList(container.image));
					containerVO.texts = parseText(XMLList(container.text));
					containerVO.hotspots = parseHotspot(XMLList(container.hotspot));
					
					containers.push(containerVO);
					
				}
				
			}
			
			return containers
			
		}
		
		public static function parseImage(list:XMLList):Vector.<ImageVO> {
			
			var images:Vector.<ImageVO> = new Vector.<ImageVO>();
			
			if (list.length() > 0) {
				
				var imageVO:ImageVO;
				
				for each(var image:XML in list) {
					
					imageVO = new ImageVO();
					imageVO.src = ContentDisplay(LoaderMax.getContent(image.@src)).rawContent;
					imageVO.x = image.@x * _scaleX;
					imageVO.y = image.@y * _scaleY;
					imageVO.width = image.@width * _scaleX;
					imageVO.height = image.@height * _scaleY;
					
					images.push(imageVO);
					
				}
				
			}
			
			return images;
			
		}
		
		public static function parseText(list:XMLList):Vector.<TextVO> {
			
			var texts:Vector.<TextVO> = new Vector.<TextVO>();
			
			if (list.length() > 0) {
				
				var textVO:TextVO;
				
				for each(var text:XML in list) {
					
					textVO = new TextVO();
					textVO.value = text.@value;
					textVO.x = text.@x * _scaleX;
					textVO.y = text.@y * _scaleY;
					textVO.size = text.@size * _scaleX;
					textVO.color = text.@color;
					textVO.bold = (text.bold == "true");
					
					texts.push(textVO);
					
				}
				
			}
			
			return texts;
			
		}
		
		public static function parseHotspot(list:XMLList):Vector.<HotspotVO> {
			
			var hotspots:Vector.<HotspotVO> = new Vector.<HotspotVO>();
			
			if (list.length() > 0) {
				
				var hotstpotVO:HotspotVO;
				
				for each(var hotspot:XML in list) {
					
					hotstpotVO = new HotspotVO();
					hotstpotVO.x = hotspot.@x * _scaleX;
					hotstpotVO.y = hotspot.@y * _scaleY;
					hotstpotVO.width = hotspot.@width * _scaleX;
					hotstpotVO.height = hotspot.@height * _scaleY;
					hotstpotVO.action = hotspot.@action;
					hotstpotVO.target = hotspot.@target;
					
					hotspots.push(hotstpotVO);
					
				}
				
			}
			
			return hotspots;
			
		}
		
		public static function parseTransition(descriptor:XML):Object {
			return {
				x: descriptor.@x,
				y: descriptor.@y,
				width: descriptor.@width,
				height: descriptor.@height,
				scaleX: descriptor.@scaleX,
				scaleY: descriptor.@scaleY,
				alpha: descriptor.@alpha
			}
		}
	}

}