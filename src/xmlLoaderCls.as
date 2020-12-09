package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
    import flash.net.*;
	import flash.external.ExternalInterface;
	import flash.system.fscommand;
	
	public class xmlLoaderCls
	{
		private var xmlLoader:URLLoader;
		private var xmlData:XML;
		private var requestUrl:URLRequest;
		
		private var returnObject:Object;
		
		public function xmlLoaderCls():void
		{
			this.xmlLoader = new URLLoader();
			this.xmlData = new XML();
			
			this.xmlLoader.addEventListener(Event.COMPLETE, xmlLoaded);
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		public function loadXML(url:String, rObj:Object):void
		{
			this.returnObject = rObj;
			try
			{
				this.requestUrl = new URLRequest(url);
				this.xmlLoader.load(this.requestUrl);
			}
			catch (e:Error)
			{
				trace("XML loader could not load " + url)
				try
				{
					ExternalInterface.call("showAlert", "XML loader could not load " + url);
				}
				catch (e:Error)
				{
					
				}
			}
		}
		private function onError(e:IOErrorEvent):void
		{
			fscommand("quit");
		}
		private function xmlLoaded(e:Event):void
		{
			this.xmlData = new XML(e.target.data);
			this.returnObject.xmlLoaded(this.xmlData);
		}
	}
}