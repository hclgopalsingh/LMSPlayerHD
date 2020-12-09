package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.media.SoundMixer;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	public class swfLoad extends EventDispatcher 
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		private var urlString:String;
		private var swfLoaderObj:Object;
		public var videoObj:MovieClip;
		private var as2VideoObj:Object;
		private var playMode:Boolean;
		private var volumeVar:Number;
		private var animationLoader:Loader;
		private var urlLoader:URLLoader;
		private var requestUrl:URLRequest;
		//private var urlLoader:URLLoader;
		private var toplayer_lc:LocalConnection;
		private var fromplayer_lc:LocalConnection;
		private var playingVersion:String;
		
		private var doubleClickCount:Number;	
		private var doubleClickActive:Boolean;
		private var actionArray:Array;		
		private var customnavArray:Array;
		private var actionTimeNum:Number;		
		private var screenshotImage:MovieClip;
		private var key:String;
		
		private var _nSwfXpos:String;
		private var _nSwfYpos:String;
		private var _nSwfWidth:String;
		private var _nSwfHeight:String;
		private var _nSwfScale:String;
		private var _spBackground:Sprite;
		private var _displayName:String;
		private var _startAt:Number;
		private var _totalTime:Number;
		private var modelObj:PlayerModel;
		
		public function swfLoad(sRef:Object, swfO:Object):void
		{
			superRef = sRef;
			swfLoaderObj = swfO;
			modelObj = PlayerModel.getInstance();
			key = modelObj.key;
			volumeVar = 100;
			actionTimeNum = -1;
			doubleClickCount = 0;
			doubleClickActive = false;
			screenshotImage = new MovieClip();
			screenshotImage.y = 50;
			//--------------------------------
			toplayer_lc = new LocalConnection();
			toplayer_lc.client = this;
			try
			{
				toplayer_lc.connect("toplayer");
			}
			catch (e:Error)
			{
				trace("Can't connect toplayer ..." );
			}
			//----------------------------------
			fromplayer_lc = new LocalConnection();
			//-----------------------------------
		}
		
		public function setClass(mc:Object):void
		{
			movObj = mc;
			movRef = movObj.sprite;
			if (movObj.visible == "false")
			{
				movRef.visible = false;
			}
		}
		
		public function setVideo(url:String, arr:Array, carr:Array, _x:String, _y:String, _width:String, _height:String, _color:Number, _scale:String, displayName:String=null, startAt:Number=1, totalTime:Number=0):void
		{	
			superRef.updateText("swfLoad::setVideo::url::" + url + "\n");
			superRef.updateText("swfLoad::setVideo::url::carr[0]" + carr[0] + ", carr[1]" + carr[1] + "\n");
			
			actionArray = arr;
			customnavArray = carr;
			//swfLoaderObj.loadSWF(url, this);
			videoObj = new MovieClip();			
			
			_nSwfXpos = _x;
			_nSwfYpos = _y;
			_nSwfWidth = _width;
			_nSwfHeight = _height;
			_nSwfScale = _scale;
			
			addBackGround(_color);
			
			if(urlString == null || (urlString != null && urlString != url)) {
				urlString = url;
				_displayName = displayName;
				if(isNaN(startAt) || startAt < 1)
				{
					_startAt = 1;
				} else {
					_startAt = startAt;
				}
				
				_totalTime = totalTime;
				
				loadSWF();		
				
				playMode = true;
			}
		}
		
		private function addBackGround(_hexValue:Number):void {
			superRef.updateText("swfLoad::addBackGround \n");
			try {
				movRef.removeChild(_spBackground)
			} catch (e:Error) {}
			
			_spBackground = new Sprite();
			_spBackground.graphics.beginFill(_hexValue, 1);
			_spBackground.graphics.drawRoundRect(0, 0, 1920, 1080, 18, 18);
			_spBackground.graphics.endFill();
			_spBackground.name = "_spBackground"
			movRef.addChild(_spBackground);
		}
		
		private function loadSWF():void
		{
			superRef.updateText("swfLoad::loadSWF \n");
			try {
				superRef.muteVolume();
			} 
			catch (e:Error) { 
				superRef.updateText("swfLoad::loadSWF::error \n");
			}
			
			try {
				superRef.showHideTimerTextField(false);
			} 
			catch (e:Error) {
				superRef.updateText("swfLoad::loadSWF::error \n");
			}
			
			requestUrl = new URLRequest(urlString);
			var context:LoaderContext = new LoaderContext(true, new ApplicationDomain());
			//context.applicationDomain = ApplicationDomain.currentDomain;
			try
			{
				//animationLoader.unloadAndStop();
			}
			catch (e:Error)
			{
				superRef.updateText("swfLoad::loadSWF::error \n");	
			}
			
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, swfLoaded);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, statusFn);
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.load(requestUrl);
			
			
			/*animationLoader = new Loader();
			animationLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
			animationLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadInProgress);
			animationLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, statusFn);
			animationLoader.load(requestUrl);*/
			superRef.updateText("loadSWF:: end of function" + " \n");
		}
		
		private function loadInProgress(e:ProgressEvent):void
		{	
			try
			{
				superRef.muteVolume();
				//mc.gotoAndStop(1);
				//trace("***** goto and stop " + mc);
				//MovieClip(animationLoader.content).gotoAndStop(1);
			}
			catch (e:Error)
			{
				
			}
		}
		
		private function statusFn(e:IOErrorEvent):void
		{	
			superRef.updateText("swfLoad::statusFn \n");
			try {
				animationLoader.unloadAndStop();
			} catch(error:Error) {
				
			}
			trace("statusFn = " + e.text);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, statusFn);
			//loadEncSWF();
		}
		
		private function encStatusFn(e:IOErrorEvent):void
		{	
			animationLoader.unloadAndStop();
			trace("encStatusFn = " + e.text);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, statusFn);
			//loadEncSWF();
		}
		
		private function loadEncSWF():void
		{
			superRef.updateText("swfLoad::loadEncSWF \n");
			requestUrl = new URLRequest(urlString);
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;			
			urlLoader = new URLLoader();
			trace("XOR: " + urlString);
			superRef.setHeaderCueName(urlString);
			superRef.setSegmentTitle(_displayName);
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, urlLoadInit);			
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, encStatusFn);
			urlLoader.load(requestUrl);
		}
		
		private function urlLoadInit(evt:Event):void {	
			superRef.updateText("swfLoad::urlLoadInit \n");
			var binaryData:ByteArray = urlLoader.data as ByteArray;	
			if(binaryData.length != 0)
			{
				trace("XXXXXXXXXXXXXXXXXXXXXXXXXXOR: " + key);
				XOR(binaryData, key);
				animationLoader = new Loader();
				animationLoader.contentLoaderInfo.addEventListener (Event.COMPLETE, encSwfLoaded);
				animationLoader.contentLoaderInfo.addEventListener (IOErrorEvent.IO_ERROR, encStatusFn);
				trace("loadEncSWF urlLoadInit");
				var lc:LoaderContext = new LoaderContext(false, new ApplicationDomain());
				lc.allowCodeImport = true;
				animationLoader.loadBytes(binaryData, lc);
			}
		}
		private function encSwfLoaded(evt:Event):void {
			superRef.updateText("swfLoad::encSwfLoaded \n");
			//superRef.clearPreloader();
			animationLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, encSwfLoaded);
			//animationLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadInProgress);
			animationLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, encStatusFn);
			try {
			superRef.resetVolume();
			
			} catch (e:Error) { }
			try {
			
			superRef.showHideTimerTextField(true);
			} catch (e:Error) {}
			superRef.bufferLoadComplete();
			as2VideoObj = new Object;
			try {
				videoObj = animationLoader.content as MovieClip;
				if (videoObj.getChildByName("mcCue")) {
					//trace("before try:1.2 : " + videoObj.mcCue);
					videoObj.mcCue.visible = modelObj.showCue;
				}
				
				playingVersion = "as3";
				/*
				if ( _nSwfXpos != "" ) {
					videoObj.x = Number(_nSwfXpos) ;				
				}
				
				if ( _nSwfYpos != "" ) {
					videoObj.y = Number(_nSwfYpos) ;				
				}
				
				if ( _nSwfWidth != "" ) {
					videoObj.width = Number(_nSwfWidth) ;				
				}
				
				if ( _nSwfHeight != "" ) {
					videoObj.height = Number(_nSwfHeight) ;			
				}
				trace("_nSwfScale: *********   " + _nSwfScale);
				if ( _nSwfScale != "" ) {
					videoObj.scaleX = videoObj.scaleY = Number(_nSwfScale) ;			
				} else {
					//videoObj.scaleX = videoObj.scaleY = 0.55;
				}
				*/
				movRef.addChild(videoObj);
				if (videoObj.totalFrames > 5)
				{
					//videoObj.gotoAndPlay(1);
					superRef.onVideoStart();
					superRef.updateText("--onVideoStart-1--");

					movRef.addEventListener(MouseEvent.CLICK, clickFn);
				}
				else
				{
					superRef.setScrubEnabled(false);
					superRef.setPlayPauseEnabled(false);
				}
			}
			catch (e:Error)
			{
				trace("AS2 Loaded");
				playingVersion = "as2";
				videoObj = null;
				movRef.addChild(animationLoader);
			}
			movRef.addEventListener(Event.ENTER_FRAME, onEnterHandler, false, 0, true);
		}
		private function  XOR(binaryData:ByteArray, key:String):void
		{
			/*
			var data:ByteArray = binaryData;
			var binKey:ByteArray = new ByteArray();
			binKey.writeUTF(key);
			var aes:AESKey = new AESKey(binKey);

			var bytesToDecrypt:int = (data.length & ~16);
			if(bytesToDecrypt > 0) {
				aes.decrypt(data, 0);
			}
			if(bytesToDecrypt >= 16) {
				aes.decrypt(data, 16);
			}
			if(bytesToDecrypt >= 32) {
				aes.decrypt(data,32);
			}
			*/
			
			var keyIndex:Number=0;
			for(var i:Number=0;i<binaryData.length;i++){
				binaryData[i]=binaryData[i]^key.charCodeAt(keyIndex);
				keyIndex++;
				if(keyIndex>=key.length)
					keyIndex=0;
			}			
		}
		private function swfReload(e:Event):void {
			superRef.updateText("swfLoad::swfReload \n");
			//superRef.clearPreloader();
			
			animationLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfReload);
			animationLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loadInProgress);
			animationLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, statusFn);
			try {
			superRef.resetVolume();
			} catch (e:Error) {
			
			}
			try {
				superRef.showHideTimerTextField(true);
			} catch (e:Error) {
			
			}
			
			superRef.bufferLoadComplete();
			as2VideoObj = new Object;
			
			try {
				videoObj = animationLoader.content as MovieClip;
				try {
					videoObj.filePath(requestUrl.url, superRef);
				} catch (e:Error) {
					trace("Error");
				}
				
				playingVersion = "as3";
				
				if (videoObj.totalFrames > 5)
				{
					//videoObj.gotoAndStop(1);
					superRef.onVideoStart();
					superRef.updateText("--onVideoStart-2--");
					movRef.addEventListener(MouseEvent.CLICK, clickFn);
					videoObj.addEventListener(Event.ENTER_FRAME, loadAllFrames);
				}
				else
				{
					superRef.setScrubEnabled(false); 
					superRef.setPlayPauseEnabled(false);
					/*if ( _nSwfXpos != "" ) {
						trace("swf x pos: " + _nSwfXpos);
						videoObj.x = Number(_nSwfXpos) ;				
					}if ( _nSwfYpos != "" ) {
						trace("swf y pos: " + _nSwfYpos);
						videoObj.y = Number(_nSwfYpos) ;				
					}if ( _nSwfWidth != "" ) {
						trace("swf width: " + _nSwfWidth);
						videoObj.width = Number(_nSwfWidth) ;				
					}if ( _nSwfHeight != "" ) {
						trace("swf height: " + _nSwfHeight);
						videoObj.height = Number(_nSwfHeight) ;			
					}
					trace("_nSwfScale: *********   " + _nSwfScale);
					if ( _nSwfScale != "" ) {
						trace("swf sclae: " + _nSwfScale);
						videoObj.scaleX = videoObj.scaleY = Number(_nSwfScale) ;			
					}	*/			
					movRef.addChild(videoObj);
					movRef.addEventListener(Event.ENTER_FRAME, onEnterHandler);
					superRef.resetVolume();
				}
			}
			catch (e:Error)
			{
				trace("AS2 Loaded");
				playingVersion = "as2";
				videoObj = null;
				movRef.addChild(animationLoader);
				movRef.addEventListener(Event.ENTER_FRAME, onEnterHandler);
				superRef.resetVolume();
			}
			
		}
		
		
		private function loadAllFrames(evt:Event):void {
			if (videoObj.framesLoaded == videoObj.totalFrames) {
				trace("all frames loaded");
				
				videoObj.removeEventListener(Event.ENTER_FRAME, loadAllFrames);
				/*if ( _nSwfXpos != "" ) {
					trace("swf x pos: " + _nSwfXpos);
					videoObj.x = Number(_nSwfXpos) ;				
				}if ( _nSwfYpos != "" ) {
					trace("swf y pos: " + _nSwfYpos);
					videoObj.y = Number(_nSwfYpos) ;				
				}if ( _nSwfWidth != "" ) {
					trace("swf width: " + _nSwfWidth);
					videoObj.width = Number(_nSwfWidth) ;				
				}if ( _nSwfHeight != "" ) {
					trace("swf height: " + _nSwfHeight);
					videoObj.height = Number(_nSwfHeight) ;			
				}
				trace("_nSwfScale: *********   " + _nSwfScale);
				if ( _nSwfScale != "" ) {
					trace("swf sclae: " + _nSwfScale);
					videoObj.scaleX = videoObj.scaleY = Number(_nSwfScale) ;			
				}*/
				//videoObj.play();
				
				
				
				//superRef.updateText("swfLoad::loadAllFrames::animationLoader.contentLoaderInfo.width" + animationLoader.contentLoaderInfo.width);
				//superRef.updateText("swfLoad::loadAllFrames::animationLoader.contentLoaderInfo.height" + animationLoader.contentLoaderInfo.height);				
				
				//videoObj.height = 768;
				//videoObj.scaleX = videoObj.scaleY;
				
				videoObj.gotoAndPlay(_startAt);
				movRef.addChild(videoObj);
				superRef.resetVolume();
				//superRef.setScrubEnabled(false);
				//superRef.setPlayPauseEnabled(false);
				movRef.addEventListener(Event.ENTER_FRAME, onEnterHandler);
			} else {
				trace("total frames is being loaded");
				videoObj.stop();
			}
		}
		
		
		
		private var interval:Number;
		public function swfLoaded(e:Event):void
		{
			superRef.updateText("swfLoad::swfLoaded \n");
			urlLoader.removeEventListener(Event.COMPLETE, swfLoaded);
			urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, statusFn);
			urlLoader.data = null;
			SoundMixer.stopAll();
			interval = setInterval(delaySwfLoaded, 500);
			superRef.muteVolume();
		}
		
		private function delaySwfLoaded():void {
			superRef.updateText("swfLoad::delaySwfLoaded \n");
			clearInterval(interval);
			SoundMixer.stopAll();
			superRef.setHeaderCueName(urlString);
			superRef.setSegmentTitle(_displayName);
			
			try {
			//animationLoader.unloadAndStop();
			} catch (e:Error) {}
			try {
			superRef.muteVolume();
			
			} catch (e:Error) { }

			try {
				superRef.showHideTimerTextField(false);
			} catch (e:Error) {
			
			}
			requestUrl = new URLRequest(urlString);
			var context:LoaderContext = new LoaderContext(true, new ApplicationDomain());
			//context.applicationDomain = ApplicationDomain.currentDomain;
			try
			{
				//animationLoader.unloadAndStop();
			}
			catch (e:Error)
			{
				
			}
			
			animationLoader = new Loader();
			animationLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfReload);
			animationLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadInProgress);
			animationLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, statusFn);
			animationLoader.load(requestUrl);
		}
		private function sefReloadError(evt:IOErrorEvent):void {
			trace("reload error");
		}
		public function clearVideo():void
		{
			try
			{
				videoObj.stop();
				try
				{
					videoObj.player_mc.stop();
				}
				catch (e:Error)
				{
					
				}
				movRef.removeChild(videoObj);
				movRef.removeChild(_spBackground);
				
			}
			catch (e:Error)
			{
				trace("No child found in swfLoad class...");
			}
			try
			{
				animationLoader.unloadAndStop();
			}
			catch (e:Error)
			{
				
			}
			try
			{
				movRef.removeEventListener(Event.ENTER_FRAME, onEnterHandler);
				movRef.removeEventListener(MouseEvent.CLICK, clickFn);
			}
			catch(e:Error)
			{
				
			}
			/*videoObj = null;
			as2VideoObj = null;*/
		}
		
		public function getPlayTime():Object
		{
			var obj:Object = new Object();
			try
			{
				if (playingVersion == "as3")
				{
					obj.currentframe = videoObj.currentFrame;
					obj.totalframes = videoObj.totalFrames;
				}
				else
				{
					obj.currentframe = as2VideoObj.currentFrame;
					obj.totalframes = as2VideoObj.totalFrames;
				}
			}
			catch (e:Error)
			{
				obj.currentframe = 1;
				obj.totalframes = 1;
			}
			//trace("vizz getPlayTime = "+obj.currentframe+" :: "+obj.totalframes)
			return obj;
		}
		
		public function setPlayTime(tm:Number):void
		{
			var actT:Number;
			if (playingVersion == "as3")
			{
				actT = Math.round((tm * videoObj.totalFrames) / 100);
				playMode ? videoObj.gotoAndPlay(actT) : videoObj.gotoAndStop(actT);
			}
			else
			{
				actT = Math.round((tm * as2VideoObj.totalFrames) / 100);
				playMode ? fromplayer_lc.send("fromplayer", "onGotoAndPlay", actT) : fromplayer_lc.send("fromplayer", "onGotoAndStop", actT);
			}
			superRef.clearAllButton();
		}
		
		public function getByteLoaded():Number
		{
			return 100;
		}
		
		public function setPause(bool:Boolean):void
		{
			playMode = !bool;
			if (bool)
			{
				if (playingVersion == "as3")
				{
					videoObj.stop();
				}
				else
				{
					try
					{
						fromplayer_lc.send("fromplayer", "onStop");
					}
					catch (e:Error)
					{
						trace("Could not connect fromplayer");
					}
				}
			}
			else
			{
				if (playingVersion == "as3")
				{
					videoObj.play();
				}
				else
				{
					try
					{
						fromplayer_lc.send("fromplayer", "onPlay");
					}
					catch (e:Error)
					{
						trace("Could not connect fromplayer");
					}
				}
			}
		}
		
		public function getPlayPauseStatus():Boolean
		{
			return playMode;
		}
		
		public function stopVideoAt(num:Number):void
		{
			playMode = false;
			if (playingVersion == "as3")
			{
				videoObj.gotoAndStop(num);
			}
			else
			{
				try
				{
					fromplayer_lc.send("fromplayer", "onGotoAndStop", num);
				}
				catch (e:Error)
				{
					trace("Could not connect fromplayer");
				}
				
			}
		}
		
		public function playVideoFrom(num:Number):void
		{
			playMode = true;
			if (playingVersion == "as3")
			{
				videoObj.gotoAndPlay(num);
			}
			else
			{
				try
				{
					fromplayer_lc.send("fromplayer", "onGotoAndPlay", num);
				}
				catch (e:Error)
				{
					trace("Could not connect fromplayer");
				}
				
			}
		}
		
		private function clickFn(e:MouseEvent):void
		{
			if (doubleClickActive)
			{
				if (doubleClickCount == 0)
				{
					setTimeout(dTimerEvent, 500);
				}
				else
				{
					playMode ? superRef.onPause() : superRef.onPlay();
				}
				doubleClickCount++;
			}
		}
		private function dTimerEvent():void
		{
			doubleClickCount = 0;
		}
		public function setVolmeFn(per:Number):void
		{
			volumeVar = per;
		}
		private function onEnterHandler(e:Event):void
		{
			var cTime:Number;
			try
			{
				if (playingVersion == "as3")
				{
					cTime = videoObj.currentFrame;
				}
				else
				{
					cTime = as2VideoObj.currentFrame;
				}
				if (actionTimeNum == -1)
				{
					for (var i:Number = 0; i < actionArray.length; i++)
					{
						if (Number(actionArray[i].actionTime) == cTime)
						{
							superRef.onVideoAction(actionArray[i], movRef, "action");
							actionTimeNum = cTime;
						}
					}
					for (var j:Number = 0; j < customnavArray.length; j++)
					{
						if (Number(customnavArray[j].actionTime) == cTime)
						{
							superRef.onVideoAction(customnavArray[j], movRef, "customnav");
							actionTimeNum = cTime;
						}
					}
				}
				if (actionTimeNum != cTime)
				{
					actionTimeNum = -1;
				}
			}
			catch (e:Error)
			{
				
			}
		}
		public function getScreenShot():BitmapData
		{
			var bitData:BitmapData = new BitmapData(modelObj.playerWidth, modelObj.playerHeight-100);
			bitData.draw(movRef, new Matrix(1, 0, 0, 1, 0, -50));
			return bitData;
		}
		
		public function showCapturedImage(bmp:Bitmap):void
		{
			try
			{
				movRef.removeChild(screenshotImage);
			}
			catch (e:Error)
			{
				
			}
			screenshotImage.addChild(bmp);
			movRef.addChild(screenshotImage);
		}
		public function removeCapturedImage():void
		{
			if (screenshotImage)
			{
				try
				{
					movRef.removeChild(screenshotImage);
				}
				catch (e:Error)
				{
					
				}
				for (var i:Number = screenshotImage.numChildren - 1; i >= 0; i--)
				{
					screenshotImage.removeChildAt(i);
				}
			}
		}
		//LocalConnection
		public function videotime(cTime:Number, tTime:Number):void
		{
			try
			{
				as2VideoObj.currentFrame = cTime;
				as2VideoObj.totalFrames = tTime;
			}
			catch (e:Error)
			{
				
			}
		}
		public function videostart(tTime:Number):void
		{
			if (tTime > 5)
			{
				superRef.onVideoStart();
				superRef.updateText("--onVideoStart-3--");
				movRef.addEventListener(MouseEvent.CLICK, clickFn);
			}
			else
			{
				superRef.setScrubEnabled(false);
				superRef.setPlayPauseEnabled(false);
			}
		}
		public function continuePlayer():void
		{
			superRef.onPlay();
		}
		public function stopPlayer():void {
			superRef.setPlayPauseEnabled(false);
		}
		public function gotostop(num:Number):void
		{
			superRef.stopVideoAt(num);
		}
		public function gotoplay(num:Number):void
		{
			superRef.playVideoFrom(num);
		}
		public function gotosegment(num:Number):void
		{
			superRef.launchStructure(num);
		}
		public function enableDoubleClick(bool:Boolean):void
		{
			//doubleClickActive = bool;
		}
	}

}