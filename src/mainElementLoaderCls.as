package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	public class mainElementLoaderCls
	{
		private var stageRef:Object;
		private var superRef:Object;
		private var xmlObj:xmlLoaderCls;
		private var swfObj:swfLoaderCls;
		private var xmlData:XML;
		
		private var loadingSub:Boolean;
		private var loadingSubChild:Boolean;
		private var assetLocation:String;
		private var elementArray:Array;
		private var subElementArray:Array;
		private var subChildElementArray:Array;
		private var elementCount:Number;
		private var subElementCount:Number;
		private var subChildElementCount:Number;
		
		private var model:PlayerModel;
		
		public function mainElementLoaderCls(suRef:Object):void
		{
			model = PlayerModel.getInstance();
			stageRef = model.stageRef;
			superRef = suRef;
			
			xmlObj = new xmlLoaderCls();
			swfObj = new swfLoaderCls();
			
			elementArray = new Array();
			subElementArray = new Array();
			subChildElementArray = new Array();
			
			loadingSub = false;
			loadingSubChild = false;
		}
		public function init(intUrl:String, assetUrl:String):void
		{
			stageRef.updateText("mainElementLoaderCls::init \n");
			elementCount = 0;
			assetLocation = assetUrl;
			xmlObj.loadXML(intUrl, this);
		}
		public function xmlLoaded(xml:XML):void
		{
			stageRef.updateText("mainElementLoaderCls::xmlLoaded:: \n");
			xmlData = xml;
			for (var i:Number = 0; i < xml.mainelements.children().length(); i++)
			{
				
				var intXML:XML = xml.mainelements.children()[i];
				
				elementArray[i] = new Object();
				elementArray[i].index = intXML.@index;
				elementArray[i].visible = intXML.@visible;
				elementArray[i].flip = intXML.@flip;
				elementArray[i].x = intXML.@x;
				elementArray[i].y = intXML.@y;
				elementArray[i].width = intXML.@width;
				elementArray[i].height = intXML.@height;
				elementArray[i].classId = intXML.@classId;
				elementArray[i].type = intXML.@type;
				elementArray[i].id = intXML.@id;
				elementArray[i].sprite = new MovieClip();
				elementArray[i].sprite.name = intXML.@id.toString();
				
				stageRef.addChild(elementArray[i].sprite);
				superRef.setPreloaderOnTop();
				
			}
			startLoad();
		}
		private function startLoad():void
		{
			stageRef.updateText("mainElementLoaderCls::startLoad\n");
			if (loadingSubChild)
			{
				if (subChildElementArray[subChildElementCount])
				{					
					stageRef.updateText("mainElementLoaderCls::startLoad::loadingSubChild\n");
					swfObj.loadSWF(assetLocation+"/"+subChildElementArray[subChildElementCount].id+"."+subChildElementArray[subChildElementCount].type, this);
				}
				else
				{
					allSwfLoaded();
				}
			}
			else if (loadingSub)
			{
				if (subElementArray[subElementCount])
				{
					stageRef.updateText("mainElementLoaderCls::startLoad::loadingSub\n");
					swfObj.loadSWF(assetLocation+"/"+subElementArray[subElementCount].id+"."+subElementArray[subElementCount].type, this);
				}
				else
				{
					allSwfLoaded();
				}
			}
			else
			{
				if (elementArray[elementCount])
				{
					stageRef.updateText("mainElementLoaderCls::startLoad"+ assetLocation + "/" + elementArray[elementCount].id + "." + elementArray[elementCount].type +"\n");
					swfObj.loadSWF(assetLocation + "/" + elementArray[elementCount].id + "." + elementArray[elementCount].type, this);
				}
				else
				{
					allSwfLoaded();
				}
			}
		}
		public function swfLoaded(content:MovieClip, loader:Loader):void
		{
			stageRef.updateText("mainElementLoaderCls::swfLoaded\n");
			if (loadingSubChild)
			{
				///superRef.updateText("Loaded Sub Child ELement: "+subChildElementArray[subChildElementCount].sprite.name);
				subChildElementArray[subChildElementCount].content = content;
				subChildElementArray[subChildElementCount].loader = loader;
				subChildElementArray[subChildElementCount].sprite.addChild(content);
				subChildElementCount++;
				startLoad();
			}
			else if (loadingSub)
			{
				///superRef.updateText("Loaded Sub ELement: "+subElementArray[subElementCount].sprite.name);
				subElementArray[subElementCount].content = content;
				subElementArray[subElementCount].loader = loader;
				subElementArray[subElementCount].sprite.addChild(content);
				subElementCount++;
				startLoad();
			}
			else
			{
				///superRef.updateText("Loaded Main ELement: " + elementArray[elementCount].sprite.name);
				elementArray[elementCount].content = content;
				elementArray[elementCount].loader = loader;
				elementArray[elementCount].sprite.addChild(content);
				elementCount++;
				startLoad();
			}
		}
		private function allSwfLoaded():void
		{
			stageRef.updateText("mainElementLoaderCls::allSwfLoaded\n");
			if (loadingSubChild)
			{
				stageRef.updateText("mainElementLoaderCls::allSwfLoaded::if\n");
				for (var k:Number = 0; k < subChildElementArray.length; k++)
				{
					subChildElementArray[k].sprite.x = subChildElementArray[k].x;
					subChildElementArray[k].sprite.y = subChildElementArray[k].y;
					if (subChildElementArray[k].width != "")
					{
						subChildElementArray[k].sprite.width = subChildElementArray[k].width;
					}
					if (subChildElementArray[k].height != "")
					{
						subChildElementArray[k].sprite.height = subChildElementArray[k].height;
					}
				}
				superRef.allElementsLoaded(elementArray, subElementArray, subChildElementArray);
			}
			else if (loadingSub)
			{
				stageRef.updateText("mainElementLoaderCls::allSwfLoaded::elseif\n");
				for (var i:Number = 0; i < subElementArray.length; i++)
				{
					subElementArray[i].sprite.x = subElementArray[i].x;
					subElementArray[i].sprite.y = subElementArray[i].y;
					if (subElementArray[i].width != "")
					{
						subElementArray[i].sprite.width = subElementArray[i].width;
					}
					if (subElementArray[i].height != "")
					{
						subElementArray[i].sprite.height = subElementArray[i].height;
					}
				}
				loadSubChildElements();
			}
			else
			{
				stageRef.updateText("mainElementLoaderCls::allSwfLoaded::else\n");
				for (var j:Number = 0; j < elementArray.length; j++)
				{
					elementArray[j].sprite.x = elementArray[j].x;
					elementArray[j].sprite.y = elementArray[j].y;
					if (elementArray[j].width != "")
					{
						elementArray[j].sprite.width = elementArray[j].width;
					}
					if (elementArray[j].height != "")
					{
						elementArray[j].sprite.height = elementArray[j].height;
					}
				}
				loadSubElements();
			}
		}
		private function loadSubElements():void
		{
			loadingSub = true;
			subElementCount = 0;
			for (var z:Number = 0; z < xmlData.subelements.length(); z++)
			{
				for (var i:Number = 0; i < xmlData.subelements[z].children().length(); i++)
				{
					var intXML:XML = xmlData.subelements[z].children()[i];
					subElementArray[subElementCount] = new Object();
					subElementArray[subElementCount].target = xmlData.subelements[z].@target;
					subElementArray[subElementCount].index = intXML.@index;
					subElementArray[subElementCount].visible = intXML.@visible;
					subElementArray[subElementCount].flip = intXML.@flip;
					subElementArray[subElementCount].x = intXML.@x;
					subElementArray[subElementCount].y = intXML.@y;
					subElementArray[subElementCount].width = intXML.@width;
					subElementArray[subElementCount].height = intXML.@height;
					subElementArray[subElementCount].classId = intXML.@classId;
					subElementArray[subElementCount].type = intXML.@type;
					subElementArray[subElementCount].id = intXML.@id;
					subElementArray[subElementCount].sprite = new MovieClip();
					subElementArray[subElementCount].sprite.name = intXML.@id;
					stageRef.addChild(subElementArray[subElementCount].sprite);
					for (var y:Number = 0; y < elementArray.length; y++)
					{
						if (elementArray[y].sprite.name == subElementArray[subElementCount].target)
						{
							elementArray[y].sprite.addChild(subElementArray[subElementCount].sprite);
						}
					}
					superRef.setPreloaderOnTop();
					subElementCount++;
				}
			}
			subElementCount = 0;
			startLoad();
		}
		
		private function loadSubChildElements():void
		{
			loadingSubChild = true;
			subChildElementCount = 0;
			for (var z:Number = 0; z < xmlData.subchildelements.length(); z++)
			{
				for (var i:Number = 0; i < xmlData.subchildelements[z].children().length(); i++)
				{
					var intXML:XML = xmlData.subchildelements[z].children()[i];
					subChildElementArray[subChildElementCount] = new Object();
					subChildElementArray[subChildElementCount].target = xmlData.subchildelements[z].@target;
					subChildElementArray[subChildElementCount].index = intXML.@index;
					subChildElementArray[subChildElementCount].visible = intXML.@visible;
					subChildElementArray[subChildElementCount].flip = intXML.@flip;
					subChildElementArray[subChildElementCount].x = intXML.@x;
					subChildElementArray[subChildElementCount].y = intXML.@y;
					subChildElementArray[subChildElementCount].width = intXML.@width;
					subChildElementArray[subChildElementCount].height = intXML.@height;
					subChildElementArray[subChildElementCount].classId = intXML.@classId;
					subChildElementArray[subChildElementCount].type = intXML.@type;
					subChildElementArray[subChildElementCount].id = intXML.@id;
					subChildElementArray[subChildElementCount].sprite = new MovieClip();
					subChildElementArray[subChildElementCount].sprite.name = intXML.@id;
					stageRef.addChild(subChildElementArray[subChildElementCount].sprite);
					for (var y:Number = 0; y < subElementArray.length; y++)
					{
						if (subElementArray[y].sprite.name == subChildElementArray[subChildElementCount].target)
						{
							subElementArray[y].sprite.addChild(subChildElementArray[subChildElementCount].sprite);
						}
					}
					superRef.setPreloaderOnTop();
					subChildElementCount++;
				}
			}
			subChildElementCount = 0;
			startLoad();
		}
	}
}