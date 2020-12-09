package
{
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.external.ExternalInterface;
	import flash.media.SoundMixer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/** 
	 * ...
	 * @author Gopal Singh
	 */
	[SWF(width="1920", height="1080", backgroundColor="#ffffff", frameRate="30")]
	public class LMSPlayerHD extends Sprite
	{
		public var controllerObj:controllerCls;
		private var model:PlayerModel;
		private var arrEvents:Array = new Array(); 
		private var bEnd:Boolean = false;
		private var isDisposed:Boolean = false;
		private var isOpenCalled:Boolean = false;
		//private var uid:String = 
		
		public function LMSPlayerHD()
		{
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorEventHandler);
			
			if(ExternalInterface.available) {
				ExternalInterface.addCallback("open", open);
				ExternalInterface.addCallback("cmsPlayerExit", cmsPlayerExit);
				ExternalInterface.addCallback("cmsPlayerPlay", cmsPlayerPlay);
				ExternalInterface.addCallback("cmsPlayerPause", cmsPlayerPause);
				ExternalInterface.addCallback("displayMode", displayMode);
				ExternalInterface.addCallback("dispose", dispose);
			}
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		
		private var intervalId:Number;
		public function dispose(value:String):String {
			try {
				isDisposed = true; 
				SoundMixer.stopAll();
				model.segmentList = [];
				controllerObj.dispose();
				intervalId = setInterval(stopAllSound, 1500); //1.5 seconds
			}
			catch (e:Error) {
				return "false";
			}
			
			return "true";
		}
		
		private function stopAllSound():void {
			if(this) {
				SoundMixer.stopAll();	
			} else {
				clearInterval(intervalId);
			}
		}
		
		public function isPlayerActive():void {
			executes("playerActive");	
		}
				
		private function uncaughtErrorEventHandler(event:UncaughtErrorEvent):void {
			if(event.error is Error) {
				updateText("uncaughtErrorEventHandler::" + event.error);
			} else {
				updateText("uncaughtErrorEventHandler::" + event.error);
			}
		}
		
		public function updateText(str:String):void
		{			
			trace("===> " + str + "\n");
			try
			{
				ExternalInterface.call("showAlert", str + "\n");
			}
			catch (e:Error)
			{
				
			}
		}
		
		private function drawRect():void {
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0xf0f000);
			sprite.graphics.drawRect(0,0,1920, 1080);
			sprite.graphics.beginFill(0xff0000);
			sprite.graphics.drawRect(10,10,1900, 1060);
			
			this.addChild(sprite);
		}
		
		private function init(e:Event = null):void 
		{
			//drawRect();	
			//return;
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			tabChildren = false;			
			
			model = PlayerModel.getInstance();
			model.stageRef = this;
			model.mainStage = stage;
			model.playerHeight = 1080;
			model.playerWidth = 1920;
			
			//--------------------------------------
			try
			{
				//stage.displayState = StageDisplayState.FULL_SCREEN;
				//stage.scaleMode = StageScaleMode.NO_SCALE;
				//stage.scaleMode = StageScaleMode.SHOW_ALL;
				stage.showDefaultContextMenu = false;
			}
			catch (e:Error)
			{
				
			}
		}
		
		/*/*updateText("value::" + jsonData);
		updateText("open:value::sessionId::" + obj.sessionId);
		updateText("open:value::homePath::" + obj.homePath);
		updateText("open:value::heading::" + obj.heading);
		updateText("open:value::totalTime::" + obj.totalTime);			
		updateText("open:value::files::" + obj.files.length);
		*/
		/*updateText("open:value::value.files[0].segmentId::" + value.files[0].segmentId);
		updateText("open:value::value.files[0].displayName::" + value.files[0].displayName);
		updateText("open:value::value.files[0].startAt::" + value.files[0].startAt);
		updateText("open:value::value.files[0].fileType::" + value.files[0].fileType);
		updateText("open:value::value.files[0].nav::" + value.files[0].nav);*/
		//return;		
		
		public function open(jsonData):void {
			if(isOpenCalled == true) {
				return;
			}
			
			if(isDisposed == true) {
				SoundMixer.stopAll();
				return;
			}
			//return;
			updateText("sdasdasafs open:if" + "open abc");
			var value:Object = JSON.parse(jsonData);
			
			var data:Object;
			if(value != null && value.homePath != undefined){
				updateText("open:if" + jsonData);
				data = value;
			}
			else {
				updateText("open:else");
				data = {
					'sessionId':'jkdfjddfk43243kjfkj',									
					'homePath':'../',									
					'heading':'काम काज',
					'totalTime':'27.33',
					'files':[
						{
							'segmentId':123,
							'displayName':'क, म और ज की आवाजें',
							'file':'content/SP0001/SP0010_NK_CH_10_SEG_01.swf',
							'startAt':'video time',
							'fileType':'swf',
							'nav':'true'
						},
						{
							'segmentId':124,
							'displayName':'क, म और ज की आवाजें',
							'file':'content/SP0001/SP0010_NK_CH_10_SEG_02_ACT.swf',
							'startAt':'video time',
							'fileType':'swf',
							'nav':'false'
						}
					]
				};
			}
			/*
			var str:String = info;			
			var tmpArr:Array = str.split("^");
			var detArr:Array = tmpArr[0].split("~");
			var displaySegString:String = detArr[5];
			
			updateText("homePath: " + data.homePath + "\n");
			//updateText("new_text: " + new_text + "\n");
			
			if(displaySegString!="") {
			model.displaySegmentList = displaySegString.split(",");
			}
			model.host = detArr[6];
			model.port = detArr[7];
			*/
			
			model.showCue = false;
			model.key = "t";			
			model.homePath = data.homePath;
			model.segmentList = data.files;
			model.heading = data.heading;
			model.totalTime = data.totalTime;
			model.sessionId = data.sessionId;
			model.previewMode = (data.previewMode == "true")?true:false;
			model.forwardEnabled = (data.forwardEnabled == "true")?true:false;
			
			
			updateText("previewMode:" + String(model.previewMode));
			
			this.controllerObj = new controllerCls(this);
			this.controllerObj.initFn();			
		}

		public function cmsPlayerExit(value:String):void {
			updateText("cmsPlayerExit called");
			//controllerObj.onPause(); 
			controllerObj.playerExit();
		}
		
		public function cmsPlayerPlay(value:Object):void {
			if(isDisposed == true) {
				SoundMixer.stopAll();
				return;
			}
			updateText("cmsPlayerPlay called");
			controllerObj.onPlay();
		}
		
		public function cmsPlayerPause(value:Object):void {
			if(isDisposed == true) {
				SoundMixer.stopAll();
				return;
			}
			updateText("cmsPlayerPause called");
			controllerObj.onPause();
		}
		
		public function displayMode(state:String):void {			
			stage.displayState = (state=="true") ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
		}
		
		public function executes(str:String, segmentId:String=""):void
		{
			var strJson:String;
			
			if(isDisposed == true) {
				SoundMixer.stopAll();
				return;
			}
		
			if(bEnd == true) {
				return;
			}
			
			if(segmentId == "1") {
				return;
			}
			
			switch(str) {
				case "exit":
					var obj:Object = this.controllerObj.getPlayTime();			
					var ms:Number = Math.round(obj.currentframe*1000/PlayerModel.FRAME_RATE);
					strJson = '{"sessionId":"' + model.sessionId + '", "segmentId":"' + segmentId + '", "event":{"action":"' + str + '", "currentPosition":' + ms + '}}';
					arrEvents = new Array();
					break;
				case "play":
					strJson = '{"sessionId":"' + model.sessionId + '", "segmentId":"' + segmentId + '", "event":{"action":"' + str + '"}}';
					arrEvents = new Array();
					break;
				case "pause":
					var obj1:Object = this.controllerObj.getPlayTime();
					var ms1:Number = Math.round(obj1.currentframe*1000/PlayerModel.FRAME_RATE);
					strJson = '{"sessionId":"' + model.sessionId + '", "segmentId":"' + segmentId + '", "event":{"action":"' + str + '", "currentPosition":' + ms1 + '}}';
					break;
				case "change":					
					strJson = '{"sessionId":"' + model.sessionId + '", "segmentId":"' + segmentId + '", "event":{"action":"' + str + '", "currentActive":' + segmentId + '}}';
					arrEvents = new Array();
					break;
				case "end":					
					var obj2:Object = this.controllerObj.getPlayTime();
					var ms2:Number = Math.round(obj2.currentframe*1000/PlayerModel.FRAME_RATE);
					strJson = '{"sessionId":"' + model.sessionId + '", "segmentId":"' + segmentId + '", "event":{"action":"' + str + '", "currentPosition":' + ms2 + '}}';
					arrEvents = new Array();
					bEnd = true;
					break;
				case "segmentBegins":
					strJson = '{"sessionId":"' + model.sessionId + '", "segmentId":"' + segmentId + '", "event":{"action":"' + str + '"}}';
					arrEvents = new Array();
					break;
				case "segmentEnds":
					strJson = '{"sessionId":"' + model.sessionId + '", "segmentId":"' + segmentId + '", "event":{"action":"' + str + '"}}';
					break;
				case "playerActive":
					strJson = '{"sessionId":"' + model.sessionId + '", "event":{"action":"' + str + '"}}';
					break;
			}
			
			if(ExternalInterface.available) {	
				//updateText("Array Before : " + arrEvents.join(", "));
				
				try
				{
					if(arrEvents.length <= 2) {
						ExternalInterface.call("event", strJson + "\n");
					} else if(arrEvents[arrEvents.length - 2] == strJson && str == "pause") {
						return;
					} else if(arrEvents[arrEvents.length - 1] == strJson && str == "segmentEnds") {
						return;
					} else {
						ExternalInterface.call("event", "aaa " + strJson + "\n");
					}
					
					if(arrEvents.length > 4) {
						arrEvents.pop();
					} else {
						arrEvents.push(strJson);
					}
				}
				catch (e:Error)
				{
					updateText("event method error: " + e.errorID + ", " + e.message);
				}
				
				//updateText("Array End : " + arrEvents.join(", "));
			}
		}
	}
}