package  
{
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Matrix;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
	import flash.media.SoundTransform;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.NetStreamAppendBytesAction;
	import flash.utils.*;
	//import com.hurlant.crypto.symmetric.AESKey;
	import org.bytearray.video.events.SlicedEvent;
	import org.bytearray.video.FLVSlice;
	import org.bytearray.video.FLVSlicer;
	import flash.utils.setTimeout;
	import flash.external.ExternalInterface;
	
	
	public class videoLoad extends MovieClip
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		
        private var videoObj:Video;
        private var connection:NetConnection;
        private var stream:NetStream;
		private var totalTime:Number;
		private var volumeVar:Number;
		private var doubleClickCount:Number;	
		private var doubleClickActive:Boolean;
		private var playMode:Boolean;
		private var videoEndStatus:Boolean;
		
		private var actionArray:Array;	
		private var customnavArray:Array;
		private var actionTimeNum:Number;
		
		private var modelObj:PlayerModel;
		
		private var screenshotImage:MovieClip;
		private var urlLoader:URLLoader;
		private var key:String;
		
		private var encrypted:Boolean;
		private var videoUrl:String;
		private var seekedPos:Number;
		private var binaryData:ByteArray;
		//private var slicedData:FLVSlice;
		
		private var _nSwfXpos:String;
		private var _nSwfYpos:String;
		private var _nSwfWidth:String;
		private var _nSwfHeight:String;
		private var _nSwfScale:String;
		private var _spBackground:Sprite;
		private var _delayInterval:Number = 0;
		
		public function videoLoad(sRef:Object):void
		{
			superRef = sRef;
			modelObj = PlayerModel.getInstance();
			key = modelObj.key;
			volumeVar = 1;
			actionTimeNum = -1;
			doubleClickCount = 0;
			doubleClickActive = true;
			screenshotImage = new MovieClip();
			screenshotImage.y = 50;
			playMode = true;
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
		public function setVideo(url:String, arr:Array, carr:Array, enc:String, _x:String, _y:String, _width:String, _height:String, _color:Number, _scale:String):void
		{
			videoUrl = url;
			encrypted = false;
			movRef.visible = false;
			actionArray = arr;
			customnavArray = carr;
			seekedPos = -1;
			totalTime = 0;
			
			

			videoObj = new Video();
			
			_nSwfXpos = _x == '' ? "0" : _x;
			_nSwfYpos = _y == '' ? "0" : _y;
			_nSwfWidth = _width == '' ? String(movRef.width) : _width;
			_nSwfHeight = _height == '' ? String(movRef.height) : _height;
			trace("scale ............ " + _scale);
			//_nSwfScale = _scale == '' ? 1 : Number(_scale);
			
			addBackGround(_color);			

			videoObj = new Video();
			videoObj.x = Number(_nSwfXpos);
			videoObj.y = Number(_nSwfYpos);
			videoObj.width = Number(_nSwfWidth);
			videoObj.height = Number(_nSwfHeight);
			//videoObj.scaleX = videoObj.scaleY = 1;
			
			movRef.addChild(videoObj);
			playMode = true;
			if (enc == "true")
			{
				encrypted = true;
				loadStart();
			}
			else
			{
				encrypted = false;
				//startVideo(null);
				loadWithoutEncStart();
				
			}
		}
		private function addBackGround(_hexValue:Number):void {			
			try {
				movRef.removeChild(_spBackground)
			} catch (e:Error) {}
			
			_spBackground = new Sprite();
			_spBackground.graphics.beginFill(_hexValue, 1);
			_spBackground.graphics.drawRoundRect(0, 0, 1024, 768, 18, 18);
			_spBackground.graphics.endFill();
			_spBackground.name = "_spBackground"
			movRef.addChild(_spBackground);
		}
		private function loadWithoutEncStart():void
		{
			var urlRequest:URLRequest = new URLRequest(videoUrl);
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, startVideo);
			urlLoader.load(urlRequest);
			
		}
		private function loadStart():void
		{
			var urlRequest:URLRequest = new URLRequest(videoUrl);
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, initBinary);
			urlLoader.load(urlRequest);
			
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
		}
		private function initBinary(e:Event ):void
		{
			binaryData = urlLoader.data as ByteArray;
			startVideo(null);
		}
		private function startVideo(evt:Event=null):void
		{
			superRef.bufferLoadComplete();
			connection = new NetConnection();
			connection.connect(null);

			if (stream)
			{
				stream.removeEventListener(NetStatusEvent.NET_STATUS, buffrCalculation);
			}
			stream = new NetStream(connection);
			stream.client = {};
			stream.client.onMetaData = ns_onMetaData;
			stream.client.onCuePoint = ns_onCuePoint;
			
			
			superRef.onVideoStart();
			movRef.addEventListener(Event.ENTER_FRAME, onEnterHandler);
			movRef.addEventListener(MouseEvent.CLICK, clickFn);
			
			if (encrypted)
			{
				
				
				try
				{
					superRef.updateText("videoLoad.as = binaryData.length = " + binaryData.length + ", key = " + key);
				}
				catch (e:Error)
				{
					
				}
				if(binaryData.length != 0)
				{
					
					stream.play(null);
					stream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
					if (seekedPos > -1)
					{
						/*
						var slicer:FLVSlicer = new FLVSlicer(binaryData);
						var firstSlice:FLVSlice = slicer.slice(seekedPos * 1000, totalTime * 1000);
						totalTime = seekedPos == 0 ? firstSlice.duration/1000 : totalTime;
						seekedPos += (((totalTime * 1000) - (seekedPos * 1000)) - firstSlice.duration)/1000;
						stream.appendBytes(firstSlice.stream);
						*/
					}
					else
					{
						
						XOR(binaryData, key);
						stream.appendBytes(binaryData);
						
						//stream.play(0);
					}
					if (!playMode)
					{
						
						//trace("onPause(): playMode" + playMode);
						setTimeout(function():void { superRef.onPause();} , 100);
					}
				}
				
				stream.addEventListener(NetStatusEvent.NET_STATUS, buffrCalculation);
				videoObj.attachNetStream(stream);
			}
			else
			{
				stream.play(videoUrl);
				videoObj.attachNetStream(stream);
				_delayInterval = setInterval(playStream, 1000);
				
				//ExternalInterface.call("alert", "checking by chetan on 2014 10 07 : stream video play");
				trace("checking by chetan on 2014 10 07 : stream video play");
			}
			var sndTransform:SoundTransform = new SoundTransform(volumeVar);
			stream.soundTransform = sndTransform;

			
		}
		
		private function playStream():void {
			videoEndStatus = false;
			clearInterval(_delayInterval);
			stream.addEventListener(NetStatusEvent.NET_STATUS, buffrCalculation);
			
			
		}
		
		public function clearVideo():void
		{
			movRef.removeEventListener(Event.ENTER_FRAME, onEnterHandler);
			movRef.removeEventListener(MouseEvent.CLICK, clickFn);
			try
			{
				stream.close();
				movRef.removeChild(videoObj);
				movRef.removeChild(_spBackground);
			}
			catch (e:Error)
			{
				trace("No child found in videoLoad class...");
			}
			try
			{
				movRef.removeChild(screenshotImage);
			}
			catch (e:Error)
			{
				trace("No screenshotImage found in videoLoad class...");
			}
		}
		 
		private function ns_onMetaData(item:Object):void {
			// Resize video instance.
			trace("item.duration: " + item.duration);
			//videoObj.width = movRef.width;
			//videoObj.height = movRef.height;
			
			if (totalTime == 0)
			{
				totalTime = item.duration;
				encrypted ? setPlayTime(0) : seekedPos = 0;
			}
			//checkNonCrypted = false;
			movRef.visible = true;
		}
		 
		private function ns_onCuePoint(item:Object):void {
			//trace("cuePoint = " + item.name);
		}
		
		public function buffrCalculation(event:NetStatusEvent):void
		{
			trace("vizz event.info.code = " + event.info.code)
			//ExternalInterface.call("alert", " event.info.code: "+ event.info.code);
			videoEndStatus = false;
			//superRef.bufferProgress("stream", stream.bufferLength, stream.bufferTime);
			switch(event.info.code)
			{
				case "NetStream.Buffer.Empty" :
					//ExternalInterface.call("alert", "NetStream.Buffer.Empty");
					/*trace((seekedPos + stream.time)+" > "+Math.round(totalTime))
					if ((seekedPos + stream.time) > Math.round(totalTime) - 1 && (seekedPos + stream.time) < Math.round(totalTime) + 1)
					{
						superRef.nextStructureLoad();
					}
					break;*/
					if (encrypted)
					{
						videoEndStatus = true;
						superRef.nextStructureLoad();
					}
					else
					{
						superRef.bufferLoadStart();
					}
					
				case "NetStream.Buffer.Full" :
					//ExternalInterface.call("alert", "NetStream.Buffer.Full");
					superRef.bufferLoadComplete();
					//stream.play(videoUrl);
					//ExternalInterface.call("alert", "checking by chetan on 2014 10 07 : stream video play");
					break;
				case "NetStream.Play.Stop":
					//ExternalInterface.call("alert", "NetStream.Play.Stop");
					videoEndStatus = true;
					superRef.nextStructureLoad();
					break;
				case "NetStream.Seek.Notify":
					//ExternalInterface.call("alert", "NetStream.Seek.Notify");
					trace("trace by chetan: append is completed");
					
					break;
				case "NetStream.Unpause.Notify":
					//ExternalInterface.call("alert", "NetStream.Unpause.Notify");
					trace("trace by chetan: append is completed");
					//startVideo();
					break;
				case "NetStream.Pause.Notify":
					//ExternalInterface.call("alert", "NetStream.Pause.Notify");
					trace("trace by chetan: pause notification append is completed");
					///startVideo();
					break;

			}
		}
		public function getPlayTime():Object
		{
			var obj:Object = new Object();
			if (totalTime == 0)
			{
				obj.currentframe = 0;
				obj.totalframes = 0;
			}
			else
			{
				//trace("stream.time = " + stream.time);
				obj.currentframe = encrypted ? seekedPos + stream.time : stream.time;
				obj.totalframes = totalTime;
			}
			return obj;
		}
		public function setPlayTime(tm:Number):void
		{
			if (Math.round(tm) == 100)
			{
				tm = 98;
			}
			seekTo(((Math.round(tm) * totalTime) / 100));
		}
		private function seekTo(num:Number):void
		{
			if (encrypted)
			{
				seekedPos = num;
				stream.seek(seekedPos);
				trace("trace by chetan: append bytes action start");
				stream.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
				trace("trace by chetan: append bytes action end");
				if (totalTime - seekedPos <= 5)
				{
					stream.bufferTime = 0;
				}
				else
				{
					stream.bufferTime = 5;
				}
				
				///loadStart();
				startVideo();
			}
			else
			{
				stream.seek(num);
			}
			superRef.clearAllButton();
		}
		public function getByteLoaded():Number
		{
			var num:Number;
			if (encrypted)
			{
				num = 100;
			}
			else
			{
				num = (stream.bytesLoaded / stream.bytesTotal) * 100;
			}
			return num;
		}
		public function setPause(bool:Boolean):void
		{
			if (bool)
			{
				stream.pause();
				playMode = false;
				movRef.removeEventListener(Event.ENTER_FRAME, onEnterHandler);
			}
			else
			{
				//stream.resume();
				setTimeout(function():void { movRef.addEventListener(Event.ENTER_FRAME, onEnterHandler); }, 1000);
				playMode = true;
				videoEndStatus ? seekTo(0) : null;
				stream.resume();
			}
		}
		public function getPlayPauseStatus():Boolean
		{
			return playMode;
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
			var sndTransform:SoundTransform = new SoundTransform(per);
			try
			{
				stream.soundTransform	= sndTransform;
			}
			catch (e:Error)
			{
				
			}
		}
		private function onEnterHandler(e:Event):void
		{
			try
			{
				if (actionTimeNum == -1)
				{
					for (var i:Number = 0; i < actionArray.length; i++)
					{
						if (actionArray[i].actionTime == Math.round(seekedPos + stream.time - 1))
						{
							superRef.onVideoAction(actionArray[i], movRef, "action");
							actionTimeNum = Math.round(seekedPos + stream.time);
						}
					}
					for (var j:Number = 0; j < customnavArray.length; j++)
					{
						if (Number(customnavArray[j].actionTime) == Math.round(seekedPos+stream.time - 1))
						{
							superRef.onVideoAction(customnavArray[j], movRef, "customnav");
							actionTimeNum = Math.round(seekedPos + stream.time);
						}
					}
				}
				if (actionTimeNum != Math.round(seekedPos + stream.time))
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
		public function stopVideoAt(num:Number):void
		{
			seekTo(num);
			playMode = false;
		}
		public function playVideoFrom(num:Number):void
		{
			//setPlayTime((num / totalTime) * 100);
			seekTo(num);
			playMode = true;
		}
		private function loadTimerFn():void
		{
			/*if (checkNonCrypted)
			{
				encrypted = true;
				loadStart();
			}*/
		}
		public function enableDoubleClick(bool:Boolean):void
		{
			doubleClickActive = bool;
		}
	}

}