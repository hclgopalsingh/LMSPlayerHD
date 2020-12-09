package  
{
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.events.*;
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
	import com.hurlant.crypto.symmetric.AESKey;
	import org.bytearray.video.events.SlicedEvent;
	import org.bytearray.video.FLVSlice;
	import org.bytearray.video.FLVSlicer;
	
	
	public class videoLoadnormal extends MovieClip
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
		
		private var actionArray:Array;	
		private var customnavArray:Array;
		private var actionTimeNum:Number;
		
		private var modelObj:PlayerModel;
		
		private var screenshotImage:Bitmap;
		private var urlLoader:URLLoader;
		private static const KEY:String = "edurix#123";
		
		private var encrypted:Boolean;
		private var checkNonCrypted:Boolean;
		private var videoUrl:String;
		private var seekedPos:Number;
		private var binaryData:ByteArray;
		private var slicedData:FLVSlice;
		
		public function videoLoadnormal(sRef:Object):void
		{
			superRef = sRef;
			volumeVar = 1;
			actionTimeNum = -1;
			modelObj = PlayerModel.getInstance();
			doubleClickCount = 0;
			doubleClickActive = true;
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
		public function setVideo(url:String, arr:Array, carr:Array):void
		{
			videoUrl = url;
			encrypted = true;
			checkNonCrypted = true;
			movRef.visible = false;
			actionArray = arr;
			customnavArray = carr;
			seekedPos = 0;
			totalTime = 0;

			videoObj = new Video();
			movRef.addChild(videoObj);
			playMode = true;
			loadStart();
		}
		private function loadStart():void
		{
			var urlRequest:URLRequest = new URLRequest(videoUrl);
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, startVideo);
			urlLoader.load(urlRequest);
		}
		private function  XOR(binaryData:ByteArray, key:String):void
		{
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
		}
		private function startVideo(e:Event):void
		{
			binaryData = urlLoader.data as ByteArray;	


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
			if (totalTime-seekedPos <= 5)
			{
				stream.bufferTime = 0;
			}
			else
			{
				stream.bufferTime = 5;
			}
			
			if(binaryData.length != 0)
			{
				if (encrypted)
				{
					XOR(binaryData, KEY);
					setTimeout(loadTimerFn, 1000);
				}
				stream.play(null);
				stream.appendBytesAction(NetStreamAppendBytesAction.RESET_BEGIN);
				if (seekedPos > 0)
				{
					var slicer:FLVSlicer = new FLVSlicer(binaryData);
					var firstSlice:FLVSlice = slicer.slice(seekedPos * 1000, totalTime * 1000);
					stream.appendBytes(firstSlice.stream);
				}
				else
				{
					stream.appendBytes(binaryData);
				}
				//loadTimer.start();

				var sndTransform:SoundTransform = new SoundTransform(volumeVar);
				stream.soundTransform = sndTransform;

				videoObj.attachNetStream(stream);
				superRef.onVideoStart();
				movRef.addEventListener(Event.ENTER_FRAME, onEnterHandler);
				movRef.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
				movRef.addEventListener(MouseEvent.MOUSE_UP, onUp);
				movRef.addEventListener(MouseEvent.CLICK, clickFn);
				if (!playMode)
				{
					setTimeout(function():void { superRef.onPause();} , 100);
				}
				stream.addEventListener(NetStatusEvent.NET_STATUS, buffrCalculation);
			}
			
		}
		public function clearVideo():void
		{
			movRef.removeEventListener(Event.ENTER_FRAME, onEnterHandler);
			movRef.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
			movRef.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			movRef.removeEventListener(MouseEvent.CLICK, clickFn);
			try
			{
				stream.close();
				movRef.removeChild(videoObj);
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
			videoObj.width = movRef.width;
			videoObj.height = movRef.height;
			if (totalTime == 0)
			{
				totalTime = item.duration;
			}
			checkNonCrypted = false;
			movRef.visible = true;
		}
		 
		private function ns_onCuePoint(item:Object):void {
			trace("cuePoint = " + item.name);
		}
		public function buffrCalculation(event:NetStatusEvent):void
		{
			trace("event.info.code = "+event.info.code)
			switch(event.info.code)
			{
				case "NetStream.Buffer.Empty" :
					/*trace((seekedPos + stream.time)+" > "+Math.round(totalTime))
					if ((seekedPos + stream.time) > Math.round(totalTime) - 1 && (seekedPos + stream.time) < Math.round(totalTime) + 1)
					{
						superRef.nextStructureLoad();
					}
					break;*/
					superRef.nextStructureLoad();
					
				case "NetStream.Buffer.Full" :
					break;
				case "NetStream.Play.Stop":
					superRef.nextStructureLoad();
					break;
				case "NetStream.Seek.Notify":
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
				obj.currentframe = seekedPos+stream.time;
				obj.totalframes = totalTime;
			}
			return obj;
		}
		public function setPlayTime(tm:Number):void
		{
			seekedPos = (tm * totalTime) / 100;
			stream.seek(seekedPos);
			stream.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
			superRef.clearAllButton();
			loadStart();
		}
		public function getByteLoaded():Number
		{
			//var num:Number = (stream.bytesLoaded / stream.bytesTotal) * 100;
			var num:Number = 100;
			return num;
		}
		public function setPause(bool:Boolean):void
		{
			if (bool)
			{
				stream.pause();
				playMode = false;
			}
			else
			{
				stream.resume();
				playMode = true;
			}
		}
		public function getPlayPauseStatus():Boolean
		{
			return playMode;
		}
		private function onDown(e:MouseEvent):void
		{
			superRef.onLongDown();
		}
		private function onUp(e:MouseEvent):void
		{
			superRef.onLongUp();
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
						if (actionArray[i].actionTime == Math.round(seekedPos+stream.time - 1))
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
		public function getScreenShot():Bitmap
		{
			var bitData:BitmapData = new BitmapData(movRef.width, movRef.height);
			bitData.draw(movRef);
			var screenshot:Bitmap = new Bitmap(bitData);
			return screenshot;
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
			screenshotImage = bmp;
			movRef.addChild(screenshotImage);
		}
		public function removeCapturedImage():void
		{
			movRef.removeChild(screenshotImage);
			screenshotImage = null;
		}
		public function stopVideoAt(num:Number):void
		{
			setPlayTime((num / totalTime) * 100);
			playMode = false;
		}
		public function playVideoFrom(num:Number):void
		{
			setPlayTime((num / totalTime) * 100);
			playMode = true;
		}
		private function loadTimerFn():void
		{
			if (checkNonCrypted)
			{
				encrypted = false;
				loadStart();
			}
		}
		public function enableDoubleClick(bool:Boolean):void
		{
			doubleClickActive = bool;
		}
	}

}