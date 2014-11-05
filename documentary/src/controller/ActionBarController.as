package controller {
	import flash.events.Event;
	import model.event.ApplicationEvent;
	import view.AppView;
	import view.elements.Hotspot;
	
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
			
			if (currentState)
				appView.hideActionBar(currentState);
			
			currentState = event.getData() as String;
			appView.setActionBarState(currentState);
		}
	
	}

}