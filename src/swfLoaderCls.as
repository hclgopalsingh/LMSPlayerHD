package
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	
	
	import flash.net.URLRequest;
	import flash.events.*
	
	public class swfLoaderCls
	{
		private var swfLoader:Loader;		
		private var returnObject:Object;
		
		private var requestUrl:URLRequest;
		private var _url:String;
		
		public function swfLoaderCls():void
		{
			this.swfLoader = new Loader();			
			this.swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded);
			this.swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			
		}
		public function loadSWF(url:String, rObj:Object):void
		{
			this.returnObject = rObj;
			_url = url;
			//trace("start loading "+url)
			try
			{
				this.requestUrl = new URLRequest(url);
				var context:LoaderContext = new LoaderContext();
				context.applicationDomain = ApplicationDomain.currentDomain;
				this.swfLoader.load(this.requestUrl, context);
			}
			catch (e:Error)
			{
				//trace("SWF loader could not load "+url)
			}
		}
		private function swfLoaded(e:Event):void
		{
			//trace(trace("SWF loaded "+_url))
			this.returnObject.swfLoaded(e.target.content, this.swfLoader);
		}
		private function errorHandler(e:Event):void
		{
			//trace(trace("file not loaded"+_url))
			//this.returnObject.swfLoaded(e.target.content, this.swfLoader);
		}
	}
}