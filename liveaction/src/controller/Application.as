package controller {
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.XMLLoader;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import model.event.ApplicationEvent;
	import model.parser.DescriptorParser;
	import model.vo.AppVO;
	import view.AppView;
	import view.utils.TextCreator;
	
	public class Application extends EventDispatcher {
		
		private const LOADER_URL:String = "descriptor/loader.xml";
		private const BASE_RES:Rectangle = new Rectangle(0, 0, 720, 1280);
		
		private var appView:AppView;
		
		public function Application(stage:Stage) {
			LoaderMax.activate([ImageLoader, XMLLoader]);
			TextCreator.setupFonts();
			
			setupResolution(stage);
			
			appView = new AppView(stage);
			appView.addEventListener(ApplicationEvent.MENU, onShowMenu);
			appView.addEventListener(ApplicationEvent.CHANGE_SCREEN, onHideMenu);
			appView.addEventListener(ApplicationEvent.ENABLE_LISTENERS, onEnableListeners);
			appView.addEventListener(ApplicationEvent.DISABLE_LISTENERS, onDisableListeners);
			
			load();
		}
		
		private function onEnableListeners(event:ApplicationEvent):void {
			appView.addEventListener(ApplicationEvent.MENU, onShowMenu);
			appView.addEventListener(ApplicationEvent.CHANGE_SCREEN, onHideMenu);
		}

		private function onDisableListeners(event:ApplicationEvent):void {
			appView.removeEventListener(ApplicationEvent.MENU, onShowMenu);
			appView.removeEventListener(ApplicationEvent.CHANGE_SCREEN, onHideMenu);
		}
		
		private function setupResolution(stage:Stage):void {
			const SCALE_X:Number = stage.fullScreenWidth / BASE_RES.width;
			const SCALE_Y:Number = stage.fullScreenHeight / BASE_RES.height;
			
			DescriptorParser.setScaleFactors(SCALE_X, SCALE_Y);
		}
		
		private function load():void {
			
			const LOADER:XMLLoader = new XMLLoader( LOADER_URL, { name:"loader", onComplete:onLoadComplete, estimatedBytes:1024 } );
			LOADER.load();
			
		}
		
		private function onLoadComplete(event:LoaderEvent):void {
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.READY));
			
			const DESCRIPTOR:XML = LoaderMax.getContent("descriptor");
			const SCREEN:AppVO = DescriptorParser.parseApp(DESCRIPTOR);
			
			appView.setup(SCREEN);
			
			new ScreenController(appView, "choose");
			new ActionBarController(appView, "actionbar_empty");
			new SocialController(appView);
			
		}
		
		private function onShowMenu(event:ApplicationEvent):void {
			appView.removeEventListener(ApplicationEvent.MENU, onShowMenu);
			appView.addEventListener(ApplicationEvent.MENU, onHideMenu);
			
			appView.showMenu();
		}
		
		private function onHideMenu(event:ApplicationEvent):void {
			appView.removeEventListener(ApplicationEvent.MENU, onHideMenu);
			appView.addEventListener(ApplicationEvent.MENU, onShowMenu);
			
			appView.hideMenu();
		}
		
	}

}