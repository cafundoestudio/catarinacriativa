package model.vo 
{
	import flash.display.Bitmap;
	import model.event.ApplicationEvent;

	public class ContainerVO extends DisplayObjVO
	{
		
		public var background:Bitmap;
		public var backgroundColor:Number;
		
		public var openEvent:ApplicationEvent;
		public var closeEvent:ApplicationEvent;
		
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