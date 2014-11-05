package model.vo 
{
	public class ScreenVO extends DisplayObjVO
	{
		
		public var transitionIn:Object;
		public var transitionOut:Object;
		public var containers:Vector.<ContainerVO>;
		public var scrollList:ScrollListVO;
		public var events:Vector.<EventVO>;
		public var unlocked:String;
		
		public function ScreenVO() {
		}
		
	}

}