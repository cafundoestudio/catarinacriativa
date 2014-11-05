package controller {
	import model.event.ApplicationEvent;
	import view.AppView;
	
	/**
	 * ...
	 * @author
	 */
	public class ActionBarController {
		
		private var appView:AppView;
		private var currentState:String;
		
		public function ActionBarController(appView:AppView, initState:String) {
			this.appView = appView;
			currentState = initState;
			
			appView.setActionBarState(currentState);
			appView.addEventListener(ApplicationEvent.CHANGE_ACTION_BAR, onChangeActionBar);
			appView.addEventListener(ApplicationEvent.ENABLE_LISTENERS, onEnableListeners);
			appView.addEventListener(ApplicationEvent.DISABLE_LISTENERS, onDisableListeners);
		}
		
		private function onEnableListeners(event:ApplicationEvent):void {
			appView.addEventListener(ApplicationEvent.CHANGE_ACTION_BAR, onChangeActionBar);
		}

		private function onDisableListeners(event:ApplicationEvent):void {
			appView.removeEventListener(ApplicationEvent.CHANGE_ACTION_BAR, onChangeActionBar);
		}
		
		private function onChangeActionBar(event:ApplicationEvent):void {
			trace(this, "CHANGE ACTION BAR");
			if (currentState)
				appView.hideActionBar(currentState);
			
			currentState = event.getData() as String;
			appView.setActionBarState(currentState);
		}
	
	}

}