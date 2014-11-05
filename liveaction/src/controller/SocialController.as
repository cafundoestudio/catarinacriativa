package controller 
{
	import com.freshplanet.ane.AirFacebook.Facebook;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MediaEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	import model.event.ApplicationEvent;
	import view.AppView;

	public class SocialController
	{
		
		private static const APP_ID:String = "557658144377916";
		private static const READ_PERMISSIONS:Array = [];
		private static const POST_PERMISSIONS:Array = [];
		
		private const URL:String = "http://cafundo.tv/clientes/catarinacriativa/";
		private const FILE:String = "saveMedia.php";
		
		private var appView:AppView;
		private var facebook:Facebook;
		private var target:String;
		
		public function SocialController(appView:AppView) 
		{
			
			this.appView = appView;
			
			appView.addEventListener(ApplicationEvent.FACEBOOK_LOGIN, onFacebookLogin);
			appView.addEventListener(ApplicationEvent.FACEBOOK_PICTURE, onFacebookPicture);
			appView.addEventListener(ApplicationEvent.ENABLE_LISTENERS, onEnableListeners);
			appView.addEventListener(ApplicationEvent.DISABLE_LISTENERS, onDisableListeners);
			
		}
		
		private function onEnableListeners(event:ApplicationEvent):void {
			appView.addEventListener(ApplicationEvent.FACEBOOK_LOGIN, onFacebookLogin);
			appView.addEventListener(ApplicationEvent.FACEBOOK_PICTURE, onFacebookPicture);
		}
		
		private function onDisableListeners(event:ApplicationEvent):void {
			appView.removeEventListener(ApplicationEvent.FACEBOOK_LOGIN, onFacebookLogin);
			appView.removeEventListener(ApplicationEvent.FACEBOOK_PICTURE, onFacebookPicture);
		}
		
		/**
		 * Do the facebook login using the API.
		 * 
		 * @param	ApplicationEvent
		 */
		private function onFacebookLogin(event:ApplicationEvent):void {
			
			target = event.getData().target as String;
			
			if (Facebook.isSupported) {
				//Init facebook api.
				facebook = Facebook.getInstance();
				facebook.init(APP_ID);
				
				//Check if have a open session.
				if (!facebook.isSessionOpen) {
					//Open new session passing a callback function.
					appView.dispatchEvent( new ApplicationEvent(ApplicationEvent.DISABLE_LISTENERS) );
					facebook.openSessionWithReadPermissions(READ_PERMISSIONS, onOpenReadSession);
					
				}
				else {
					
					appView.dispatchEvent(new ApplicationEvent(ApplicationEvent.CHANGE_SCREEN, true, false, {target:this.target}));
					
				}
				
			}
			else {
				
				appView.closeAllPopups();
				
			}
			
		}
		
		private function onOpenReadSession(success:Boolean, userCancelled:Boolean, error:String = null):void {
			appView.dispatchEvent( new ApplicationEvent( ApplicationEvent.ENABLE_LISTENERS ) );
			
			if (success) {
				//Go to logged screen.
				changeScreen();
				
			}
			else {
				//Back to previous screen.
				appView.closeAllPopups();
				
			}
			
		}
		
		/**
		 * Starts the device camera.
		 * 
		 * @param	ApplicationEvent indicating to start camera.
		 */
		private function onFacebookPicture(event:ApplicationEvent):void {
			
			target = event.getData().target as String;
			
			var deviceCameraAPP:CameraUI = new CameraUI();
			if (CameraUI.isSupported) {
                //starts the device camera
				deviceCameraAPP.addEventListener(MediaEvent.COMPLETE, imageCaptured);
                deviceCameraAPP.launch(MediaType.IMAGE);
			}
			
		}
		
		/**
		 * Reads the data of the captured image.
		 * 
		 * @param	MediaEvent containing image data.
		 */
		private function imageCaptured(event:MediaEvent):void {
			
			appView.dispatchEvent( new ApplicationEvent(ApplicationEvent.DISABLE_LISTENERS) );
			
			var imagePromise:MediaPromise = event.data;
			var byteArray:ByteArray = new ByteArray();
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(imagePromise.file, FileMode.READ);
			fileStream.readBytes(byteArray);
			fileStream.close();
			
			sendData(byteArray);
			
		}
		
		/**
		 * Sends the data to a server.
		 * 
		 * @param	ByteArray containing the image data.
		 */
		private function sendData(data:ByteArray):void {
			
			const REQUEST:URLRequest = new URLRequest(URL + FILE);
			const LOADER:URLLoader = new URLLoader();
			
			REQUEST.method = URLRequestMethod.POST;
			REQUEST.contentType = "application/octet-stream";
			REQUEST.data = data;
			
			LOADER.addEventListener(Event.COMPLETE, onMediaSended);
			LOADER.load(REQUEST);
			
		}
		
		/**
		 * Shares the link on facebook.
		 * 
		 * @param	event
		 */
		private function onMediaSended(event:Event):void {
			
			const LOADER:URLLoader = event.currentTarget as URLLoader;
			//Share parameters
			const PARAMS:Object = { 
				message: "Here is my Big Bang Self!",
				picture: URL + LOADER.data,
				caption: "Big Bang Self in Quest"
				
			};
			
			//Open a dialog requesting the share confirmation.
			facebook.dialog("feed", PARAMS, onFacebookPosted, true);
			
		}


		private function onFacebookPosted(data:Object):void {
			appView.dispatchEvent( new ApplicationEvent( ApplicationEvent.ENABLE_LISTENERS ) );
			
			if (data.params != null)
				changeScreen();
			
		}
		
		private function changeScreen():void {
			appView.dispatchEvent(new ApplicationEvent(ApplicationEvent.CHANGE_SCREEN, true, false, { target:this.target } ));
		}
		
	}

}