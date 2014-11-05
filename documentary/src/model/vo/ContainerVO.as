package model.vo 
{
	import flash.display.Bitmap;

	public class ContainerVO extends DisplayObjVO
	{
		
		public var background:Bitmap;
		public var backgroundColor:Number;
		
		public var containers:Vector.<ContainerVO>;
		public var images:Vector.<ImageVO>;
		public var texts:Vector.<TextVO>;
		public var hotspots:Vector.<HotspotVO>;
		public var states:Vector.<ContainerVO>;
		
		public function ContainerVO() 
		{
		}
		
	}

}