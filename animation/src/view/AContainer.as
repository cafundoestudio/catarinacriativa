package view {
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import model.vo.ContainerVO;
	import model.vo.HotspotVO;
	import model.vo.ImageVO;
	import model.vo.TextVO;
	import view.elements.Hotspot;
	import view.utils.TextCreator;
	
	public class AContainer extends Sprite {
		
		public function AContainer() {
			super();
		}
		
		protected function createContainer(containerVO:ContainerVO):Sprite {
			
			const SPRITE:Sprite = new Sprite();
			SPRITE.name = containerVO.name;
			SPRITE.x = containerVO.x;
			SPRITE.y = containerVO.y;
			SPRITE.alpha = containerVO.alpha;
			
			if (SPRITE.alpha == 0) {
				
				SPRITE.visible = false;
				
			}
			
			if (containerVO.background) {
				SPRITE.addChild(containerVO.background);
			}
			
			for each (var container:ContainerVO in containerVO.containers) {
				SPRITE.addChild(createContainer(container));
			}
			
			if (containerVO.backgroundColor) {
				SPRITE.graphics.beginFill(containerVO.backgroundColor, 1);
			}
			
			SPRITE.graphics.drawRect(0, 0, containerVO.width, containerVO.height);
			SPRITE.graphics.endFill();
			
			createImages(SPRITE, containerVO.images);
			createTexts(SPRITE, containerVO.texts);
			createHotspots(SPRITE, containerVO.hotspots);
			
			SPRITE.blendMode = BlendMode.LAYER;
			
			return SPRITE;
			
		}
		
		protected function createImages(holder:Sprite, images:Vector.<ImageVO>):void {
			var bmp:Bitmap;
			for each (var imgVO:ImageVO in images) {
				bmp = imgVO.src;
				bmp.x = imgVO.x;
				bmp.y = imgVO.y;
				bmp.width = imgVO.width;
				bmp.height = imgVO.height;
				
				holder.addChild(bmp);
			}
		}
		
		protected function createTexts(holder:Sprite, texts:Vector.<TextVO>):void {
			var text:TextField;
			for each (var txtVO:TextVO in texts) {
				text = TextCreator.create(txtVO.value, txtVO.size, txtVO.color, txtVO.bold, TextCreator.QUICKSAND, new Rectangle(0, 0, txtVO.width, txtVO.height));
				text.x = txtVO.x;
				text.y = txtVO.y;
				
				holder.addChild(text);
			}
		}
	
		protected function createHotspots(holder:Sprite, hotspots:Vector.<HotspotVO>):void {
			var hotspot:Hotspot;
			
			for each (var hotspotVO:HotspotVO in hotspots) {				
				hotspot = new Hotspot(hotspotVO);
				hotspot.enableClick();
				
				holder.addChild(hotspot);
			}
		}
		
	}

}