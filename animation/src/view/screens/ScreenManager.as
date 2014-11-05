package view.screens {
	import flash.display.Sprite;
	import model.vo.ContainerVO;
	import model.vo.ScreenVO;
	
	/**
	 * ...
	 * @author
	 */
	public class ScreenManager extends Sprite{
		
		private var currentScreen:Screen;
		private var tempScreen:Screen;
		
		private var transitionTime:Number;
		
		public function ScreenManager(containerVO:ContainerVO) {
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