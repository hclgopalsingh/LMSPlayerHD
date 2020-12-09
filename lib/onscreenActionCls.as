package  
{
	/**
	 * ...
	 * @author Mitr...
	 */
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class onscreenActionCls 
	{
		private var superRef:Object;
		private var movRef:Array;
		private var movObj:Array;
		private var currentMCs:Array;
		private var currentLoader:Array;
		private var currentCount:Number;
		private var assetFolder:String;
		private var loadedLength:Number;
		private var loading:Boolean;
		private var referenceMc:MovieClip;
		private var urlLoader:URLLoader;
		
		private var modelObj:PlayerModel;
		private static const KEY:String = "t";
		
		public function onscreenActionCls(sRef:Object):void
		{
			superRef = sRef;
			movObj = new Array();
			movRef = new Array();
			currentMCs = new Array();
			currentLoader = new Array();
			currentCount = 0;
			loadedLength = 0;
			loading = false;
			modelObj = PlayerModel.getInstance();
		}
		public function setClass(mc:Object, aFolder:String):void
		{
			assetFolder = aFolder;
			movObj.push(mc);
			movRef.push(mc.sprite);
			if (mc.visible == "false")
			{
				mc.sprite.visible = false;
			}
		}
		public function showButton(obj:Object, refMc:MovieClip, type:String):void
		{
			referenceMc = refMc;	
			currentMCs[currentCount] = new MovieClip();
			currentMCs[currentCount].action = obj.classParam;
			currentMCs[currentCount].type = type;
			if (type == "customnav")
			{
				currentMCs[currentCount].instances = obj.instances;				
			}
			try
			{
				if (obj.actionInterfaceId == "")
				{
					currentMCs[currentCount].url = obj.actionInterfaceUrl;
				}
				else
				{
					currentMCs[currentCount].url = assetFolder + "/" + obj.actionInterfaceId + ".swf";
				}
			}
			catch (e:Error)
			{
				trace("Some issue with obj.actionInterfaceId...");
			}
			referenceMc.addChild(currentMCs[currentCount]);
			currentMCs[currentCount].x = obj.actionX;
			currentMCs[currentCount].y = obj.actionY;
			if (obj.nav)
			{
				currentMCs[currentCount].nav = obj.nav;
				trace("vizz = " + obj.nav);
				if (obj.nav == "false")
				{
					superRef.setScrubEnabled(false);
					superRef.setPlayPauseEnabled(false);
				}
			}
			
			if (Number(obj.actionWidth) != 0)
			{
				currentMCs[currentCount].actionWidth = Number(obj.actionWidth);
			}
			if (Number(obj.actionHeight) != 0)
			{
				currentMCs[currentCount].actionHeight = Number(obj.actionHeight);
			}
			if (obj.classParam != "")
			{
				currentMCs[currentCount].addEventListener(MouseEvent.CLICK, clickHandler);
			}
			currentCount++;
			
			if (!loading)
			{
				currentLoader[loadedLength] = new Loader();
				currentLoader[loadedLength].contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);		
				currentLoader[loadedLength].contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, statusFn);
				var requestUrl:URLRequest = new URLRequest(currentMCs[loadedLength].url);
				trace("currentMCs[loadedLength].url: " + currentMCs[loadedLength].url);
				var context:LoaderContext = new LoaderContext();
				//context.applicationDomain = ApplicationDomain.currentDomain;
				currentLoader[loadedLength].load(requestUrl);
				loading = true;
			}
		}
		public function clearMC():void {
			try {
				for (var i:uint = 0; i < currentCount+1; i++) {
					var obj:MovieClip = referenceMc.getChildByName(currentMCs[i].name) as MovieClip;
					referenceMc.removeChild(obj);
				}
			} catch (e:Error) {}
		}
		//----------------------------------------------------------------------
		private function statusFn(e:IOErrorEvent):void
		{
			currentLoader[loadedLength].unloadAndStop();
			trace("statusFn = " + e.text);
			loadEncSWF();
		}
		private function loadEncSWF():void
		{
			var requestUrl:URLRequest = new URLRequest(currentMCs[loadedLength].url);
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;			
			urlLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, urlLoadInit);
			urlLoader.load(requestUrl);
		}
		private function urlLoadInit(evt:Event):void {	
			var binaryData:ByteArray = urlLoader.data as ByteArray;	
			if(binaryData.length != 0)
			{
				XOR(binaryData, KEY);
				currentLoader[loadedLength] = new Loader();				
				currentLoader[loadedLength].contentLoaderInfo.addEventListener (Event.COMPLETE, swfLoaded);
				currentLoader[loadedLength].loadBytes(binaryData, new LoaderContext());
			}
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
		//----------------------------------------------------------------------
		public function swfLoaded(e:Event):void
		{
			try
			{
				currentMCs[loadedLength].addChild(currentLoader[loadedLength]);
				currentMCs[loadedLength].width = currentMCs[loadedLength].actionWidth;
				currentMCs[loadedLength].height = currentMCs[loadedLength].actionHeight;
				if (currentMCs[loadedLength].type == "customnav")
				{
					for (var i:Number = 0; i < currentMCs[loadedLength].instances.length; i++)
					{
						if (currentMCs[loadedLength].instances[i].classParam != "")
						{
							currentLoader[loadedLength].content[currentMCs[loadedLength].instances[i].instance + "_var"] = currentMCs[loadedLength].instances[i].classParam;
							currentLoader[loadedLength].content[currentMCs[loadedLength].instances[i].instance].addEventListener(MouseEvent.CLICK, customClickHandler);
						}
					}
				}
				loadedLength++;
				if (loadedLength < currentCount)
				{
					currentLoader[loadedLength] = new Loader();
					currentLoader[loadedLength].contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
					var requestUrl:URLRequest = new URLRequest(currentMCs[loadedLength].url);
					var context:LoaderContext = new LoaderContext();
					//context.applicationDomain = ApplicationDomain.currentDomain;
					currentLoader[loadedLength].load(requestUrl);
				}
				else
				{
					trace("All Loaded");
					loadedLength = 0;
					loading = false;
				}
			}
			catch (e:Error)
			{
				
			}
		}
		public function clearAllButton():void
		{
			superRef.setScrubEnabled(true);
			superRef.setPlayPauseEnabled(true);
			for (var i:Number = 0; i < currentMCs.length; i++)
			{
				currentMCs[i].action = "";
				for (var y:Number = currentMCs[i].numChildren-1; y >= 0; y--)
				{
					currentMCs[i].removeChildAt(y);
					currentLoader[i].unloadAndStop();
				}
				referenceMc.removeChild(currentMCs[i])
			}
			currentMCs = new Array();
			currentLoader = new Array();
			currentCount = 0;
		}
		private function clearButton(mc:MovieClip):void
		{
			referenceMc.removeChild(mc)
		}
		private function clickHandler(e:MouseEvent):void
		{
			eventExecute(e.currentTarget.action);
		}
		private function customClickHandler(e:MouseEvent):void
		{
			eventExecute(e.currentTarget.parent[e.currentTarget.name + "_var"]);
		}
		private function eventExecute(str:String):void
		{
			if (str.indexOf(","))
			{
				var strArr:Array = str.split(",");
				str = strArr[0];
			}
			switch(str.toLowerCase())
			{
				case "play":
					superRef.onPlay();
					break;
				case "gotostop":
					superRef.stopVideoAt(Number(strArr[1]));
					clearAllButton();
					break;
				case "gotoplay":
					superRef.playVideoFrom(Number(strArr[1]));
					break;
				case "gotosegment":
					superRef.launchStructure(Number(strArr[1]) - 1);
					break;
				case "remove":
					clearAllButton();
					break;
			}
		}
	}

}