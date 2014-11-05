package controller {
	import com.greensock.loading.LoaderMax;
	import com.juankpro.ane.localnotif.Notification;
	import com.juankpro.ane.localnotif.NotificationEvent;
	import com.juankpro.ane.localnotif.NotificationManager;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import model.event.ApplicationEvent;
	import model.parser.DescriptorParser;
	import model.vo.PopupVO;
	import model.vo.ScreenVO;
	import view.AppView;
	
	public class ScreenController {
		
		private var screenStack:Vector.<String>;
		private var unlockedScreens:Dictionary;
		private var syncTimer:Timer;
		
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
			
			startSyncTimer();
		}
		
		public function addListeners():void {
			appView.addEventListener(ApplicationEvent.BACK, onBackScreen);
			appView.addEventListener(ApplicationEvent.CHANGE_SCREEN, onChangeScreen);
			appView.addEventListener(ApplicationEvent.OPEN_POPUP, onOpenPopup);
			appView.addEventListener(ApplicationEvent.CLOSE_POPUP, onClosePopup);
			appView.addEventListener(ApplicationEvent.UNLOCK_EPISODE, onUnlockEpisode);
			appView.addEventListener(ApplicationEvent.CREATE_PUSH, onCreatePush);
			appView.addEventListener(ApplicationEvent.NAVIGATE_TO_URL, onNavigateToURL);
		}
		
		public function removeListeners():void {
			appView.removeEventListener(ApplicationEvent.BACK, onBackScreen);
			appView.removeEventListener(ApplicationEvent.CHANGE_SCREEN, onChangeScreen);
			appView.removeEventListener(ApplicationEvent.OPEN_POPUP, onOpenPopup);
			appView.removeEventListener(ApplicationEvent.CLOSE_POPUP, onClosePopup);
			appView.removeEventListener(ApplicationEvent.UNLOCK_EPISODE, onUnlockEpisode);
		}
		
		private function onNavigateToURL(event:ApplicationEvent):void {
			
			var URL:String = event.getData().target;
			if (URL != '') {
				
				navigateToURL(new URLRequest(URL), '_blank');
				
			}
			
		}
		
		private function onCreatePush(event:ApplicationEvent):void {
			
			if (true || NotificationManager.isSupported) {
				
				var notificationManager:NotificationManager = new NotificationManager();
				
				var notification:Notification = new Notification();
				notification.actionLabel = "OK";
				notification.body = "Confira nosso novo episódio!";
				notification.title = "Bruxinha Catarina";
				notification.fireDate = new Date((new Date()).time + (10 * 1000));
				notification.numberAnnotation = 1;
				notification.actionData = { };
				
				notificationManager.notifyUser("NOTIFICATION_CODE_001", notification);
				
			}
			
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
			trace(this, "ON BACK SCREEN");
			removeListeners();	
			setTimeout( addListeners, 500 );
			
			currentScreen = screenStack.pop();
			setScreen();
		}
		
		private function onChangeScreen(event:ApplicationEvent):void {
			if ( screenStack.indexOf(event.getData().target) >= 0 )
				screenStack.pop();
			
			if ( currentScreen != event.getData().target )
				screenStack.push(currentScreen);
			
			currentScreen = event.getData().target;
			
			setScreen();
			trace(this, "ON CHANGE SCREEN", screenStack);
		}
		
		private function onUnlockEpisode(event:ApplicationEvent):void {
			trace(this, "ON UNLOCK EPISODE");
			unlockedScreens[currentScreen] = event.getData().target;
			currentScreen = event.getData().target;
			setScreen();
		}
		
		private function onOpenPopup(event:ApplicationEvent):void {
			
			appView.openPopup(event.getData().target);
			
		}
		
		private function onClosePopup(event:ApplicationEvent):void {
			
			appView.closePopup(event.getData().target);
			
		}
		
		private function startSyncTimer():void {
			
			syncTimer = new Timer(1000, 0);
			syncTimer.addEventListener(TimerEvent.TIMER, onSyncTimer);
			syncTimer.start();
			
		}
		
		private function onSyncTimer(event:TimerEvent):void {
			
			const LOADER:URLLoader = new URLLoader();
			const REQUEST:URLRequest = new URLRequest("http://192.168.0.22/scripts/checkEpisodes.php");
			
			LOADER.addEventListener(Event.COMPLETE, onSyncComplete);
			LOADER.load(REQUEST);
			
		}
		
		private function onSyncComplete(event:Event):void {
			
			const MAP:Object = JSON.parse(event.target.data);
			unlockedScreens = new Dictionary();
			
			for(var episode:Object in MAP.episodes) {
				
				unlockedScreens[episode] = MAP.episodes[episode];
				
			}
			
		}
		
	}

}