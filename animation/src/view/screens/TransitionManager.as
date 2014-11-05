package view.screens {
	import flash.display.Sprite;
	import model.event.ApplicationEvent;
	import model.vo.ContainerVO;
	import model.vo.EventVO;
	import model.vo.PopupVO;
	import model.vo.ScreenVO;
	
	/**
	 * ...
	 * @author
	 */
	public class TransitionManager extends Sprite{
		
		private var currentScreen:Screen;
		private var tempScreen:Screen;
		
		private var transitionTime:Number;
		
		public function TransitionManager(containerVO:ContainerVO) {
			super();
			this.transitionTime = 0.5;
			
			graphics.drawRect(0, 0, containerVO.width, containerVO.height);
			name = containerVO.name;
			x = containerVO.x;
			y = containerVO.y;
		}
		
		public function setScreen(vo:ScreenVO):void {
			if (currentScreen) {
				setScreenWithTransition(vo);
			} else {
				currentScreen = new Screen(vo);
				addChild(currentScreen);
				currentScreen.transitionIn();
			}
			
			for each (var event:EventVO in vo.events) {
				dispatchEvent( new ApplicationEvent( event.type, true, false, event.data) );
			}
		}
		
		private function setScreenWithTransition(vo:ScreenVO):void {
			
			currentScreen.mouseChildren = false;
			currentScreen.mouseEnabled = false;
			
			tempScreen = currentScreen;
			currentScreen = new Screen(vo);
			
			currentScreen.mouseChildren = false;
			currentScreen.mouseEnabled = false;
			
			addChild(currentScreen);
			
			tempScreen.transitionOut(onTransitionComplete);
			currentScreen.transitionIn();
			
		}
		
		private function onTransitionComplete():void {
			removeChild(tempScreen);
			tempScreen = null;
			
			currentScreen.mouseChildren = true;
			currentScreen.mouseEnabled = true;
			
		}
	}

}