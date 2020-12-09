package  
{
	import flash.display.MovieClip;
	import flash.events.*;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
	import flash.media.SoundTransform;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.utils.*;
	
	public class videoLoad 
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
		private var playMode:Boolean;
		
		private var actionArray:Array;
		private var actionTimeNum:Number;
		
		private var modelObj:PlayerModel;
		
		private var screenshotImage:Bitmap;
		
		public function videoLoad(sRef:Object):void
		{
			superRef = sRef;
			volumeVar = 1;
			actionTimeNum = -1;
			modelObj = PlayerModel.getInstance();
			doubleClickCount = 0;
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
		public function setVideo(url:String, arr:Array, enc:String):void
		{
			movRef.visible = false;
			actionArray = arr;
			videoObj = new Video();
			movRef.addChild(videoObj);
			 
			connection = new NetConnection();
			connection.connect(null);
			 
			stream = new NetStream(connection);
			stream.client = {};
			stream.client.onMetaData = ns_onMetaData;
			stream.client.onCuePoint = ns_onCuePoint;
			stream.bufferTime = 9;
			stream.addEventListener(NetStatusEvent.NET_STATUS, buffrCalculation, false, 0, true);
			stream.play(url);
			
			var sndTransform:SoundTransform = new SoundTransform(volumeVar);
			stream.soundTransform = sndTransform;
			 
			videoObj.attachNetStream(stream);
			superRef.onVideoStart();
			movRef.addEventListener(Event.ENTER_FRAME, onEnterHandler);
			movRef.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			movRef.addEventListener(MouseEvent.MOUSE_UP, onUp);
			movRef.addEventListener(MouseEvent.CLICK, clickFn);
			
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
			totalTime = item.duration;
			movRef.visible = true;
		}
		 
		private function ns_onCuePoint(item:Object):void {
			trace("cuePoint = " + item.name);
		}
		public function buffrCalculation(event:NetStatusEvent):void
		{
			switch(event.info.code)
			{
				case "NetStream.Buffer.Empty" :
					trace("Buffer.Empty");
					break;
					
					
				case "NetStream.Buffer.Full" :
					trace("Buffer.Full");
					break;
				case "NetStream.Play.Stop":
					trace("NetStream.Play.Stop");
					superRef.nextStructureLoad();
					break;
			}
		}
		public function getPlayTime():Object
		{
			var obj:Object = new Object();
			obj.currentframe = stream.time;
			obj.totalframes = totalTime;
			return obj;
		}
		public function setPlayTime(tm:Number):void
		{
			var actT:Number = (tm * totalTime) / 100;
			stream.seek(actT);
			superRef.clearAllButton();
		}
		public function getByteLoaded():Number
		{
			var num:Number = (stream.bytesLoaded / stream.bytesTotal) * 100;
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
						if (actionArray[i].actionTime == Math.round(stream.time - 1))
						{
							superRef.onVideoAction(actionArray[i], movRef);
							actionTimeNum = Math.round(stream.time);
						}
					}
				}
				if (actionTimeNum != Math.round(stream.time))
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
			stream.seek(num);
			superRef.onPause();
		}
		public function playVideoFrom(num:Number):void
		{
			stream.seek(num);
			superRef.onPlay();
		}
	}

}