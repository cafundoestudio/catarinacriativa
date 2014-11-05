package view {
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import model.vo.AppVO;
	import model.vo.PopupVO;
	import model.vo.ScreenVO;
	import view.screens.Popup;
	import view.screens.TransitionManager;
	
	public class AppView extends AContainer {
		
		private const ANIMATION_TIME:Number = 0.5;
		
		private var actionbar:ActionBar;
		private var screenContainer:TransitionManager;
		private var popupContainer:Popup;
		private var menu:Sprite;
		
		public function AppView(stage:Stage) {
			super();
			
			stage.addChild(this);
			graphics.drawRect(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
		}		
		
		public function setup(vo:AppVO):void {
			actionbar = new ActionBar(vo.actionbar);
			screenContainer = new TransitionManager(vo.screenContainer);
			popupContainer = new Popup();
			menu = createContainer(vo.menu);
			
			addChild(screenContainer);
			addChild(actionbar);
			addChild(menu);
			addChild(popupContainer);
		}
		
		public function setScreen(screenVO:ScreenVO):void {
			screenContainer.setScreen(screenVO);
		}
		
		public function setPopup(popupVO:PopupVO):void {
			popupContainer.setPopup(popupVO);
		}
		
		public function setActionBarState(name:String):void {
			actionbar.setState(name);
		}
		
		public function hideActionBar(name:String):void {
			actionbar.hideState(name);
		}
		
		public function showMenu():void {
			TweenLite.to(this, ANIMATION_TIME, { x:menu.width } );
		}
		
		public function hideMenu():void {
			TweenLite.to(this, ANIMATION_TIME, { x:0 } );
		}
		
		public function openPopup(target:String):void {
			
			const SPRITE:Sprite = popupContainer.getChildByName(target) as Sprite;
			if (SPRITE) {
				
				SPRITE.visible = true;
				SPRITE.alpha = 1;
				
			}
			
		}
		
		public function closePopup(target:String):void {
			
			const SPRITE:Sprite = popupContainer.getChildByName(target) as Sprite;
			if (SPRITE) {
				
				SPRITE.visible = false;
				SPRITE.alpha = 0;
				
			}
			
		}
		
	}

}