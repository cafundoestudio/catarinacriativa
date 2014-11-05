package view.utils {
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author
	 */
	public class TextCreator {
		
		public static const DARK_BLUE:uint = 0x223062;
		public static const WHITE:uint = 0xFFFFFF;
		public static const GREEN:uint = 0x82BF40;
		
		[Embed(source="../../../bin/assets/fonts/Cabin-Regular.otf", advancedAntiAliasing="true",fontFamily="Sans",fontName="Cabin",fontWeight="normal",mimeType="application/x-font",embedAsCFF="false")]
		private static var Cabin:Class;
		
		[Embed(source="../../../bin/assets/fonts/Cabin-Bold.otf", advancedAntiAliasing="true",fontFamily="Sans",fontName="Cabin",fontWeight="bold",mimeType="application/x-font",embedAsCFF="false")]
		private static var CabinBold:Class;
		
		[Embed(source="../../../bin/assets/fonts/DIN-Alternate.ttf", advancedAntiAliasing="true",fontFamily="Sans",fontName="DINAlternate",fontWeight="normal",mimeType="application/x-font",embedAsCFF="false")]
		private static var DINAlternate:Class;
		
		[Embed(source="../../../bin/assets/fonts/DIN-Alternate-Bold.ttf", advancedAntiAliasing="true",fontFamily="Sans",fontName="DINAlternate",fontWeight="bold",mimeType="application/x-font",embedAsCFF="false")]
		private static var DINAlternateBold:Class;
		
		[Embed(source="../../../bin/assets/fonts/Roboto-Regular.ttf", advancedAntiAliasing="true",fontFamily="Sans",fontName="Roboto",fontWeight="normal",mimeType="application/x-font",embedAsCFF="false")]
		private static var RobotoRegular:Class;
		
		[Embed(source="../../../bin/assets/fonts/Roboto-Italic.ttf", advancedAntiAliasing="true",fontFamily="Sans",fontName="Roboto",fontWeight="italic",mimeType="application/x-font",embedAsCFF="false")]
		private static var RobotoItalic:Class;
		
		public static const CABIN:String = "Cabin";
		public static const DIN:String = "DINAlternate";
		public static const ROBOTO:String = "Roboto";
		
		public static function setupFonts():void {
			Font.registerFont(Cabin);
			Font.registerFont(CabinBold);
			Font.registerFont(DINAlternate);
			Font.registerFont(DINAlternateBold);
			Font.registerFont(RobotoRegular);
			Font.registerFont(RobotoItalic);
		}
		
		public static function create(text:String, size:Object, color:Object, bold:Boolean = false, fontName:String = DIN, bounds:Rectangle = null):TextField {
			const FORMAT:TextFormat = new TextFormat(fontName);
			FORMAT.size = size;
			FORMAT.color = color;
			FORMAT.bold = bold;
			
			const FIELD:TextField = new TextField();
			FIELD.defaultTextFormat = FORMAT;
			FIELD.antiAliasType = "advanced";
			FIELD.embedFonts = true;
			FIELD.selectable = false;
			FIELD.text = text;
			if (bounds.width > 0 && bounds.height > 0) {
				FIELD.width = bounds.width;
				FIELD.height = bounds.height;
				FIELD.multiline = true;
				FIELD.wordWrap = true;
			}
			else {
				FIELD.autoSize = TextFieldAutoSize.CENTER;
			}
			
			return FIELD;
		}
	
	}

}