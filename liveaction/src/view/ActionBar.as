package view {
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import model.vo.ContainerVO;
	
	/**
	 * ...
	 * @author
	 */
	public class ActionBar extends AContainer {
		
		private const ANIMATION_TIME:Number = 0.5;
		
		private var states:Dictionary;
		
		public function ActionBar(vo:ContainerVO) {
			super();
			addChild(createContainer(vo));
			
			states = new Dictionary();
			createStates(vo.states);
		}
		
		private function createStates(statesVO:Vector.<ContainerVO>):void {
			var state:Sprite;
			
			for each (var stateVO:ContainerVO in statesVO) {
				state = createContainer(stateVO);
				state.alpha = 0;
				state.visible = false;
				
				states[state.name] = state;
				addChild(state);
			}
		}
		
		public function hideState(name:String):void {
			if (states[name]) {
				TweenLite.to(states[name], ANIMATION_TIME, { alpha:0, onComplete:disable, onCompleteParams:[states[name]] } );
			}
		}
			
		private function disable(state:Sprite):void {
			state.visible = false;
		}
		
		public function setState(name:String):void {
			trace(this, "SET STATE: ", name, states);
			if (states[name]) {
				trace(this, "CONFIRM");
				//states[name].alpha = 1;
				states[name].visible = true;
				TweenLite.to(states[name], ANIMATION_TIME, { alpha:1 } );
			}
		}
		
		
	}

}