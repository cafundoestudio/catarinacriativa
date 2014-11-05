package controller {
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	import model.event.ApplicationEvent;
	import view.AppView;
	
	/**
	 * ...
	 * @author
	 */
	public class AccelerometerController {
		
		// Defines the correct movement
		private const SUCCESS_COUNT:int = 6;
		private const X_LIMIT:Number = 0.35;
		private const Y_LIMIT:Number = 1.75;
		private const Z_LIMIT:Number = 0.35;
		
		private var accelerometer:Accelerometer;
		private var shakeCountX:int;
		private var shakeCountZ:int;
		
		private var appView:AppView;
		private var targetPopUp:String;
		
		public function AccelerometerController(appView:AppView) {
			this.appView = appView;
			this.appView.addEventListener(ApplicationEvent.START_ACCELEROMETER, onStart);
			this.appView.addEventListener(ApplicationEvent.STOP_ACCELEROMETER, onStop);
			
			accelerometer = new Accelerometer();
		}
		
		private function success():void {
			accelerometer.removeEventListener(AccelerometerEvent.UPDATE, onUpdate);

			appView.closeAllPopups();
			appView.openPopup(targetPopUp);
		}
		
		/**
		 * Starts the accelerometer listeners.
		 * 
		 * @param	ApplicationEvent indicating to start accelerometer.
		 */
		private function onStart(event:ApplicationEvent):void {
			trace(this, "START ACCELEROMETER");
			accelerometer.addEventListener(AccelerometerEvent.UPDATE, onUpdate);
			
			targetPopUp = event.getData().target;
			shakeCountX = 0;
			shakeCountZ = 0;
		}
		
		/**
		 * Stops the accelerometer listeners.
		 * 
		 * @param	ApplicationEvent indicating to stop accelerometer.
		 */
		private function onStop(event:ApplicationEvent):void {
			trace(this, "STOP ACCELEROMETER");
			accelerometer.removeEventListener(AccelerometerEvent.UPDATE, onUpdate);
		}
		
		/**
		 * Process the accelerometer data and verifies if the movement is valid.
		 * 
		 * @param	Accelerometer event containing the accelerometer data.
		 */
		private function onUpdate(event:AccelerometerEvent):void {
			const REACHED_ON_X:Boolean = event.accelerationX >= X_LIMIT;
			const REACHED_ON_Y:Boolean = event.accelerationY >= Y_LIMIT;
			const REACHED_ON_Z:Boolean = event.accelerationZ >= Z_LIMIT;
			
			//Movement must occur only on X and Z axes.
			if (REACHED_ON_X) shakeCountX++;
			if (REACHED_ON_Z) shakeCountZ++;
			
			//If Y axis movement occurs, restart the movement count for correct axes.
			if (REACHED_ON_Y) {
				shakeCountX = 0;
				shakeCountZ = 0;
			}
			
			if (shakeCountX >= SUCCESS_COUNT && shakeCountZ >= SUCCESS_COUNT) success();
			
		}
	
	}

}