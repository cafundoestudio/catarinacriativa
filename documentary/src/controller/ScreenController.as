package controller {
	import com.greensock.loading.LoaderMax;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import model.event.ApplicationEvent;
	import model.parser.DescriptorParser;
	import model.vo.PopupVO;
	import model.vo.ScreenVO;
	import view.AppView;
	
	/**
	 * ...
	 * @author
	 */
	public class ScreenController {
		
		private const UNLOCKED:String = "_unlocked";
		
		private var screenStack:Vector.<String>;
		private var unlockedScreens:Dictionary;
		
		private var currentScreen:String;
		private var currentUnlockedScreen:String;
		
		private var appView:AppView;
		
		public function ScreenController(appView:AppView, initScreen:String) {
			screenStack = new Vector.<String>();
			unlockedScreens = new Dictionary();
			
			this.appView = appView;
			addListeners();
			
			currentScreen = initScreen;
			setScreen();
		}
		
		public function addListeners():void {
			appView.addEventListener(ApplicationEvent.BACK, onBackScreen);
			appView.addEventListener(ApplicationEvent.CHANGE_SCREEN, onChangeScreen);
			appView.addEventListener(ApplicationEvent.OPEN_POPUP, onOpenPopup);
			appView.addEventListener(ApplicationEvent.CLOSE_POPUP, onClosePopup);
			appView.addEventListener(ApplicationEvent.UNLOCK_EPISODE, onUnlockEpisode);
		}
		
		public function removeListeners():void {
			appView.removeEventListener(ApplicationEvent.BACK, onBackScreen);
			appView.removeEventListener(ApplicationEvent.CHANGE_SCREEN, onChangeScreen);
			appView.removeEventListener(ApplicationEvent.OPEN_POPUP, onOpenPopup);
			appView.removeEventListener(ApplicationEvent.CLOSE_POPUP, onClosePopup);
			appView.removeEventListener(ApplicationEvent.UNLOCK_EPISODE, onUnlockEpisode);
		}
		
		private function setScreen():void {
			if (unlockedScreens[currentScreen])
				currentScreen = unlockedScreens[currentScreen];
			
			const DESCRIPTOR:XML = LoaderMax.getContent(currentScreen);
			const SCREEN:ScreenVO = DescriptorParser.parseScreen(DESCRIPTOR);
			const POPUP:PopupVO = DescriptorParser.parsePopup(DESCRIPTOR);
			
			appView.setScreen(SCREEN);
			appView.setPopup(POPUP);
		}
		
		private function onBackScreen(event:ApplicationEvent):void {
			removeListeners();	
			setTimeout( addListeners, 500 );
			
			currentScreen = screenStack.pop();
			setScreen();
		}
		
		private function onChangeScreen(event:ApplicationEvent):void {
			screenStack.push(currentScreen);
			currentScreen = event.getData().target;
			
			setScreen();
		}
		
		private function onUnlockEpisode(event:ApplicationEvent):void {
			const TARGET:String = event.getData().target;
			const TARGET_UNLOCKED:String = TARGET + UNLOCKED;
			
			if ( !screenStack.length )
				screenStack.push(currentScreen);
			
			unlockedScreens[TARGET] = TARGET_UNLOCKED;
			currentScreen = TARGET_UNLOCKED;
			setScreen();
		}
		
		private function onOpenPopup(event:ApplicationEvent):void {
			
			appView.openPopup(event.getData().target);
			
		}
		
		private function onClosePopup(event:ApplicationEvent):void {
			
			appView.closePopup(event.getData().target);
			
		}
		
	}

}