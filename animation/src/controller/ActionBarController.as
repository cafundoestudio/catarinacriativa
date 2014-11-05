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