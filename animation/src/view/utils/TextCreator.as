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
		
		[Embed(source="../../../bin/assets/fonts/Quicksand-Bold.ttf", advancedAntiAliasing="true",fontFamily="Quicksand",fontName="Quicksand",fontWeight="bold",mimeType="application/x-font",embedAsCFF="false")]
		private static var QuicksandBold:Class;
		
		[Embed(source="../../../bin/assets/fonts/Quicksand-Regular.ttf", advancedAntiAliasing="true",fontFamily="Quicksand",fontName="Quicksand",fontWeight="normal",mimeType="application/x-font",embedAsCFF="false")]
		private static var Quicksand:Class;
		
		[Embed(source="../../../bin/assets/fonts/WendyOne-Regular.ttf", advancedAntiAliasing="true",fontFamily="WendyOne",fontName="WendyOne",fontWeight="normal",mimeType="application/x-font",embedAsCFF="false")]
		private static var WendyOne:Class;
		
		public static const QUICKSAND:String = "Quicksand";
		public static const WENDYONE:String = "WendyOne";
		
		public static function setupFonts():void {
			Font.registerFont(QuicksandBold);
			Font.registerFont(Quicksand);
			Font.registerFont(WendyOne);
		}
		
		public static function create(text:String, size:Object, color:Object, bold:Boolean = false, fontName:String = QUICKSAND, bounds:Rectangle = null):TextField {
			trace(TextCreator, "BOLD: ", bold);
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