package view.screens {
	import com.greensock.TweenLite;
	import flash.utils.Dictionary;
	import model.vo.ContainerVO;
	import model.vo.HotspotVO;
	import model.vo.ScreenVO;
	import model.vo.ScrollListVO;
	import view.AContainer;
	import view.elements.Hotspot;
	import view.uicomponents.scroll.ScrollList;
	
	/**
	 * ...
	 * @author
	 */
	public class Screen extends AContainer {
			
		private var transitions:Dictionary;
		
		public function Screen(vo:ScreenVO) {
			super();
			
			transitions = new Dictionary();
			transitions[transitionIn] = vo.transitionIn;
			transitions[transitionOut] = vo.transitionOut;
			
			name = vo.name;
			x = vo.x;
			y = vo.y;
			alpha = vo.alpha;
			
			createContainers(vo.containers);
			createScrollList(vo.scrollList);
		}
		
		private function createContainers(containers:Vector.<ContainerVO>):void {
			for each(var container:ContainerVO in containers) {
				addChild(createContainer(container));
			}
		}

		private function createScrollList(vo:ScrollListVO):void {
			if (vo) {
				
				const SCROLL_LIST:ScrollList = new ScrollList(vo.width, vo.height);
				
				SCROLL_LIST.x = vo.x;
				SCROLL_LIST.y = vo.y;
				
				var item:Hotspot;
				
				for each (var itemVO:HotspotVO in vo.items) {
					item = new Hotspot(itemVO);
					SCROLL_LIST.addItem(item);
				}
				
				addChild(SCROLL_LIST);
				
			}
		}
		
		public function transitionIn(onComplete:Function = null):void {
			transitions[transitionIn].onComplete = onComplete;
			TweenLite.to(this, 0.5, transitions[transitionIn]);
		}
		
		public function transitionOut(onComplete:Function = null):void {
			transitions[transitionOut].onComplete = onComplete;
			TweenLite.to(this, 0.5, transitions[transitionOut]);
		}
		
	}

}