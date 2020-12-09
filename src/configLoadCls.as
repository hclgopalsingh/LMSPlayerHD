package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.fscommand;
	public class configLoadCls
	{
		private var controlRef:Object;
		private var xmlObj:xmlLoaderCls;
		private var configLoaded:Boolean;
		private var modelObj:PlayerModel
		
		public function configLoadCls(cRef:Object):void
		{
			modelObj = PlayerModel.getInstance();
			this.controlRef = cRef;
			configLoaded = false;
			
			this.xmlObj = new xmlLoaderCls();
		}
		public function init():void
		{
			controlRef.updateText("configLoad class initiated...\n");
			controlRef.updateText("modelObj.structurePath: coming from Localconnection = " + modelObj.structurePath + "\n");
			if (modelObj.structurePath)
			{
				trace("modelObj.structurePath = " + modelObj.structurePath);
				configLoaded = true;
				this.xmlObj.loadXML(modelObj.structurePath, this);
			}
			else
			{
				controlRef.updateText("xmlPath not found in javascript...\n");
				controlRef.updateText("config.xml loading started...\n");
				configLoaded = false;
				this.xmlObj.loadXML("../config/config.xml", this);
				//this.xmlObj.loadXML("config/config.xml", this);
			}
		}
		private function paramLoadHandler(evt:Event):void {
			trace(evt.target.data);
			//var urlVariable:URLVariables = new URLVariables(String(evt.target.data));
			var xml:XML = new XML(String(evt.target.data));
			//var xmlPath:String = urlVariable.xmlPath;
			var xmlPath:String = xml.xmlPath;
			
			//var str:String = urlVariable.init;						
			var str:String = xml.init;
			trace("display list: " + str);
			var tmpArr:Array = str.split("^");
			var detArr:Array = tmpArr[0].split("~");
			var displaySegString:String = detArr[5];
			modelObj.host = detArr[6];
			modelObj.port = detArr[7];
			if(displaySegString!="") {
				modelObj.displaySegmentList = displaySegString.split(",");	
				//ExternalInterface.call("alert", "XMLSocket Host: ["+modelObj.host+"] Port: ["+modelObj.port+"]");
			}
			
			controlRef.updateText("Data received from javascript xmlPath = " + xmlPath + " ...\n");
							
			this.xmlObj.loadXML(xmlPath, this);
		}
		private function errorHandler(evt:IOErrorEvent):void {
			
		}
		public function xmlLoaded(xml:XML):void
		{
			if (configLoaded)
			{
				controlRef.updateText("configLoadCls::xmlLoaded::Structure xml loaded...\n");
				controlRef.updateText(xml + "\n");
				this.controlRef.setConfig(xml);
			}
			else
			{
				controlRef.updateText("configLoadCls::xmlLoaded::config.xml loaded...\n");
				controlRef.updateText("Data received from config.xml = " + xml.path.@url + " ...\n");
				configLoaded = true;
				if (xml.path.@url == "js")
				{
					controlRef.updateText("Checking xmlPath in javascript...\n");
					
					if (modelObj.isB2CDemo) {
						var urlRequest:URLRequest = new URLRequest("param.txt");
						var urlLoader:URLLoader = new URLLoader();
						urlLoader.addEventListener(Event.COMPLETE, paramLoadHandler);
						urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
						urlLoader.load(urlRequest);
						
					} else {

						try
						{
							var xmlPath:String = ExternalInterface.call("xmlPath");
							
							
							/* start modification for b2c - added by chetan*/
							try {
								var str:String = ExternalInterface.call("init");
								//ExternalInterface.call("alert", "display list: " + str);
								trace("display list: " + str);
								var tmpArr:Array = str.split("^");
								var detArr:Array = tmpArr[0].split("~");
								var displaySegString:String = detArr[5];
								
								if(displaySegString!="") {
									modelObj.displaySegmentList = displaySegString.split(",");	
									//ExternalInterface.call("alert", "XMLSocket Host: ["+modelObj.host+"] Port: ["+modelObj.port+"]");
								}
								
								modelObj.host = detArr[6];
								modelObj.port = detArr[7];
								trace("display list number: "+displaySegString);
							} catch (e:Error) {
								
							}
							
							/* end modification for b2c*/		
							
							
							
							controlRef.updateText("Data received from javascript xmlPath = " + xmlPath + " ...\n");
							
							this.xmlObj.loadXML(xmlPath, this);
							
							
						}
						catch (e:Error)
						{
							trace("xmlPath mentioned as 'js' in config.xml");
							fscommand("quit");
						}
					}
				}
				else
				{
					controlRef.updateText("Structure XML started loading from " + xml.path.@url + " ...\n");
					configLoaded = true;
					xmlObj.loadXML(xml.path.@url, this);
				}
			}
		}
	}
}