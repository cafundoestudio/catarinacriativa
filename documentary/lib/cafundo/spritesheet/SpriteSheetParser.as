package cafundo.spritesheet {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author
	 */
	public class SpriteSheetParser {
		
		private static var imagesMap:Dictionary = new Dictionary();
		
		public static function clear():void {
			
			for each (var item:Bitmap in imagesMap) {
				item = null;
			}
			
			imagesMap = null;
			imagesMap = new Dictionary();
			System.gc();
		}
		
		public static function parse(spriteSheet:Bitmap, xml:XML):void {
			var image:Bitmap;
			var name:String;
			
			for each (var subTexture:XML in xml.SubTexture) {
				image = slice(spriteSheet, subTexture);
				image.smoothing = true;
				
				image.name = subTexture.@name;
				imagesMap[image.name] = image;
			}
		}
		
		private static function slice(mainImage:Bitmap, sliceParams:XML):Bitmap {
			const X:Number = sliceParams.@x;
			const Y:Number = sliceParams.@y;
			
			const WIDTH:Number = sliceParams.@width;
			const HEIGHT:Number = sliceParams.@height;
			
			const FRAME_X:Number = sliceParams.@frameX;
			const FRAME_Y:Number = sliceParams.@frameY;
			
			var frameWidth:Number = sliceParams.@frameWidth;
			var frameHeight:Number = sliceParams.@frameHeight;
			
			if (!frameWidth)
				frameWidth = WIDTH;
			if (!frameHeight)
				frameHeight = HEIGHT;
			
			const CUT_DATA:BitmapData = new BitmapData(frameWidth, frameHeight, true, 0);
			const CUT_RECT:Rectangle = new Rectangle(X, Y, WIDTH, HEIGHT);
			
			const DRAW_X:Number = (frameWidth - WIDTH) - ((frameWidth - WIDTH) + FRAME_X);
			const DRAW_Y:Number = (frameHeight - HEIGHT) - ((frameHeight - HEIGHT) + FRAME_Y);
			CUT_DATA.copyPixels(mainImage.bitmapData, CUT_RECT, new Point(DRAW_X, DRAW_Y));
			
			return new Bitmap(CUT_DATA);
		}
		
		public static function getBitmap(name:String):Bitmap {
			return imagesMap[name];
		}
		
		public static function getBitmapsBy(prefix:String):Vector.<Bitmap> {
			const NAMES:Array = new Array();
			const IMAGES:Vector.<Bitmap> = new Vector.<Bitmap>();
			
			for (var key:String in imagesMap) {
				if (key.indexOf(prefix) == 0)
					NAMES.push(key);
			}
			
			NAMES.sort();
			
			for each (var name:String in NAMES) {
				IMAGES.push(imagesMap[name]);
			}
			
			return IMAGES;
		}
	
	}

}