package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.system.fscommand;
	
	public class controllerCls
	{
		private var stageRef:Object;
		private var mainRef:Object;
		private var xmlObj:xmlLoaderCls;
		private var swfLoaderObj:swfLoaderCls;
		//private var keyboardObj:keyboardClass;
		
		private var configLoadObj:configLoadCls;
		private var mainElemLoadObj:mainElementLoaderCls;
		
		private var xmlPath:String;
		private var assetFolder:String;
		private var preloaderPath:String;
		
		private var elementArray:Array;
		private var subElementArray:Array;
		private var subChildElementArray:Array;
		private var structureArray:Array;
		private var structureId:Number;
		private var headerStr:String;
		private var totalVideoTime:String;
		private var maskSprite:Sprite;
		private var playerLanguage:String
		
		// Classes // ====================================================
		private var powerIconObj:powerClass;
		
		private var volumeObj:volumeClass;
		private var volumeSliderObj:volumeSliderClass;
		
		private var sectionObj:sectionClass;
		private var sectionListObj:sectionListClass;
		
		private var scrubObj:mcScrubBarClass;
		private var playObj:playClass;
		private var pauseObj:pauseClass;
		private var autoPlayObj:autoPlayIconClass;
		private var previewModeIconObj:previewModeIconClass;
		private var totalTimeObj:totalTimeClass;
		private var bottomStripObj:bottomStripClass;
		private var videocontroller:videoControllerClass;
		
		
		private var videoObj:videoLoad;
		private var swfObj:swfLoad;
		private var preloadObj:preloaderCls;
		//private var explainObj:explainClass;
		//private var exploreObj:exploreClass;
		//private var evaluateObj:evaluateClass;
		//private var rounderIconObj:rounderIconClass;
		//private var rounderObj:rounderCls;
		private var onscreenObj:onscreenActionCls;
		//private var angleObj:angleIconClass;
		
		private var headerObj:headerClass;
		private var exitDialogObj:exitDialogClass;
		private var bufferObj:bufferLoaderClass;
		
		
		//private var maskIconObj:maskIconClass;
		//private var exitIconObj:exitIconClass;
		
		
		
		//private var maskObj:maskClass;
		
		//private var blankAreaObj:blankareaClass;
		
		//private var displayModeBtn:displayModeBtnClass;
		
		// Classes // ====================================================
		private var model:PlayerModel;
		private var actionStarted:Boolean;
		
		private var soundVol:SoundTransform = new SoundTransform(1); // added by chetan b
		
		public function controllerCls(mRef:Object):void
		{
			model = PlayerModel.getInstance();
			stageRef = model.stageRef;
			mainRef = mRef;
			xmlObj = new xmlLoaderCls();
			swfLoaderObj = new swfLoaderCls();
			
			configLoadObj = new configLoadCls(this);
			mainElemLoadObj = new mainElementLoaderCls(this);
		
			structureId = 0;
			
			maskSprite = new Sprite();
			maskSprite.graphics.beginFill(0xFF0000, 0.5);
			maskSprite.graphics.drawRect(0, 0, 1920, 1080);
			maskSprite.graphics.endFill();
			
			// Keyboard // ====================================================
			//keyboardObj = new keyboardClass(this);
			
			// Classes // ====================================================
			powerIconObj = new powerClass(this);
			
			volumeObj = new volumeClass(this);
			volumeSliderObj = new volumeSliderClass(this);
			
			sectionObj = new sectionClass(this);
			sectionListObj = new sectionListClass(this);
			
			scrubObj = new mcScrubBarClass(this);
			scrubObj.addEventListener(DataEvent.DATA, scrubChangeHandler);
			
			playObj = new playClass(this);
			pauseObj = new pauseClass(this);
			autoPlayObj = new autoPlayIconClass(this);
			previewModeIconObj = new previewModeIconClass(this);
			totalTimeObj = new totalTimeClass(this);
			bottomStripObj = new bottomStripClass(this);
			//explainObj = new explainClass(this);
			//exploreObj = new exploreClass(this);
			//evaluateObj = new evaluateClass(this);
			
			onscreenObj = new onscreenActionCls(this);
			//rounderIconObj = new rounderIconClass(this);
			//rounderObj = new rounderCls(this);
			
			//angleObj = new angleIconClass(this);
			
			headerObj = new headerClass(this);
			exitDialogObj = new exitDialogClass(this);			
			bufferObj = new bufferLoaderClass(this);
			//displayModeBtn = new displayModeBtnClass(this);
			
		
			//this.maskIconObj = new maskIconClass(this);
			//this.exitIconObj = new exitIconClass(this);
		
			//this.maskObj = new maskClass(this);
		
			//this.blankAreaObj = new blankareaClass(this);
			
			videoObj = new videoLoad(this);
			swfObj = new swfLoad(this, swfLoaderObj);
			preloadObj = new preloaderCls(this);
			actionStarted = false;
			// Classes // ====================================================
		}
		
		public function initFn():void
		{
			updateText("initFn initiated...\n");
			//configLoadObj.init();
			
			xmlPath = model.homePath + "config/interface_videoplayer.xml";
			assetFolder = model.homePath + "presentation/hindinuggetplayer";
			preloaderPath = assetFolder + "/preloader.swf";
			//keyboardObj.setXmlPath(xml.config.player.keyboard.@url);
			//loadStructure(XML(xml.structure), preloaderPath);
			loadStructure(model.segmentList, preloaderPath);
		}
		public function setConfig(xml:XML):void
		{
			updateText("model.displaySegmentList.length: " + model.displaySegmentList.length + "\n");
			
			if(model.displaySegmentList.length>0) {
				var finalXML:String = "<?xml version='1.0' encoding='UTF-8'?><playerxml>";
				var fileName:String = "";
				finalXML += String(xml.config);
				for (var j:uint = 0; j<xml.structure.filename.length(); j++) {
					xml.structure.filename[j].@refId = j+1;
					xml.structure.filename[j].dummy = j;
				}			
				for (var i:uint = 0; i<model.displaySegmentList.length; i++) {
					for (j = 0; j<xml.structure.filename.length(); j++) {
						if (model.displaySegmentList[i] == xml.structure.filename[j].@refId) {
							fileName += xml.structure.filename[j];						
						}
					}
				}			
				xml.structure.setChildren(new XMLList(fileName));
				finalXML += xml.structure;			
				finalXML += "</playerxml>";		
				
				xml = XML(finalXML);
				
			}
			
			updateText("after: " + xml + "\n");
						
			xmlPath = model.homePath + "config/interface_videoplayer.xml";
			assetFolder = model.homePath + "presentation/hindinuggetplayer";
			preloaderPath = assetFolder + "/preloader.swf";
			//keyboardObj.setXmlPath(xml.config.player.keyboard.@url);
			loadStructure(model.segmentList, preloaderPath);
		}		
	
		public function preloaderLoaded():void
		{
			updateText("controllerCls::preloaderLoaded::" + xmlPath + "\n");
			updateText("controllerCls::preloaderLoaded::" + assetFolder + "\n");
			mainElemLoadObj.init(xmlPath, assetFolder);
		}
		
		public function allElementsLoaded(eArr:Array, seArr:Array, scArr:Array):void
		{
			updateText("controllerCls::allElementsLoaded \n");
			elementArray = eArr;
			subElementArray = seArr;
			subChildElementArray = scArr;
			
			preloadObj.clearPreLoader();
			checkClasses();
			try {
				if (playerLanguage == "hindi") {
				MovieClip(stageRef.getChildByName("watermark")).visible=true;
			} else {
				MovieClip(stageRef.getChildByName("watermark")).visible=true;
			}
			} catch (e:Error) {}
		}
		
		public function clearPreloader():void {
			updateText("controllerCls::clearPreloader \n");
			preloadObj.clearPreLoader();
		}
		
		private function loadStructure(data:Array, pUrl:String):void
		{
			updateText("controllerCls::loadStructure::" + model.heading + "\n");
			updateText("controllerCls::loadStructure::" + model.totalTime + "\n");
			
			headerStr = model.heading;
			totalVideoTime = model.totalTime ? model.totalTime : "Hello";
			structureArray = new Array();
			for (var i:Number = 0; i < data.length; i++)
			{
				structureArray[i] = new Object();
				structureArray[i].id = data[i].segmentId;
				structureArray[i].displayName = data[i].displayName;
				structureArray[i].name = data[i].name;
				structureArray[i].url = data[i].file;
				structureArray[i].bgColor = 0xffffff;
				structureArray[i].startAt = data[i].startAt;
				structureArray[i].totalTime = data[i].totalTime;
				
				updateText("controllerCls::loadStructure::" + structureArray[i].url + "\n");
				updateText("controllerCls::loadStructure::totalTime::" + data[i].totalTime + "\n");
				
				//structureArray[i].supportingFile = xml.children()[i].@supportingFile ? xml.children()[i].@supportingFile : "";
				//structureArray[i].encryption = xml.children()[i].@encryption ? xml.children()[i].@encryption : "false";
				structureArray[i].type = data[i].fileType;
				
				if(	data[i].isCompleted != undefined && 
					(data[i].isCompleted == true || data[i].isCompleted == "true")) {
					structureArray[i].isCompleted = true;
				} else {
					structureArray[i].isCompleted = false;
				}
				
				if(data[i].totalTime) {
					structureArray[i].totalTime = Number(data[i].totalTime);	
				} else {
					structureArray[i].totalTime = 0;
				}
				
				if (data[i].nav)
				{
					structureArray[i].nav = data[i].nav;
				}
				structureArray[i].action = new Array();
				structureArray[i].customnav = new Array();
			}
			preloadObj.init(pUrl, swfLoaderObj);
		}
		
		// Set Classes Area Starts...............
		private function checkClasses():void
		{
			updateText("controllerCls::checkClasses \n");
			for (var i:Number = 0; i < elementArray.length; i++)
			{
				if (elementArray[i].classId != "")
				{
					setClasses(elementArray[i], elementArray[i].classId);
				}
			}
			checkSubClasses();
		}
		private function checkSubClasses():void
		{
			updateText("controllerCls::checkSubClasses \n");
			for (var i:Number = 0; i < subElementArray.length; i++)
			{
				if (subElementArray[i].classId != "")
				{
					setClasses(subElementArray[i], subElementArray[i].classId);
				}
			}
			checkSubChildClasses();
		}
		private function checkSubChildClasses():void
		{
			updateText("controllerCls::checkSubChildClasses \n");
			for (var i:Number = 0; i < subChildElementArray.length; i++)
			{
				if (subChildElementArray[i].classId != "")
				{
					setClasses(subChildElementArray[i], subChildElementArray[i].classId);
				}
			}
			model.stageRef.addChild(maskSprite);
			model.stageRef.mask = maskSprite;
			launchStructure(0);
			this.onhideTool();
			this.model.stageRef.addEventListener(KeyboardEvent.KEY_DOWN, displayKey);
			this.model.stageRef.addEventListener(MouseEvent.CLICK, this.onStgClk);		
		}
		private function setClasses(spriteObj:Object, cId:String):void
		{
			updateText("controllerCls::setClasses::GG::" + cId + " \n");
			
			switch(cId)
			{
				case "powerClass":
					powerIconObj.setClass(spriteObj);
					break;
				
				case "volumeClass":
					volumeObj.setClass(spriteObj);
					break;
				
				case "volumeSliderClass":
					volumeSliderObj.setClass(spriteObj);
					break;
				
				case "markerplayerClass":
					//markerPlayerObj.setClass(spriteObj);
					break;
				
				case "sectionClass":
					sectionObj.setClass(spriteObj);
					break;
				
				case "sectionListClass":
					//sectionListObj.setClass(spriteObj);
					break;
				
				case "mcScrubBarClass":
					updateText("controllerCls::setClasses::mcScrubBarClass::before \n");
					scrubObj.setClass(spriteObj);
					updateText("controllerCls::setClasses::mcScrubBarClass::after \n");					
					break;
				
				case "playClass":
					playObj.setClass(spriteObj);
					break;
				
				case "pauseClass":
					pauseObj.setClass(spriteObj);
					break;
				
				case "autoPlayIconClass":
					autoPlayObj.setClass(spriteObj);
					break;
				
				case "previewModeIconClass":
					updateText("controllerCls::setClasses::previewModeIconClass::before \n");
					previewModeIconObj.setClass(spriteObj);
					updateText("controllerCls::setClasses::previewModeIconClass::after \n");
					break;
					
				case "totalTimeClass":
					totalTimeObj.setClass(spriteObj);
					break;
				
				case "videoClass":
					videoObj.setClass(spriteObj);
					swfObj.setClass(spriteObj);
					break;
				case "videoControllerClass":
					//to do
					break;
				
				case "explainClass":
					//explainObj.setClass(spriteObj);
					break;
				
				case "exploreClass":
					//exploreObj.setClass(spriteObj);
					break;
				
				case "evaluateClass":
					//evaluateObj.setClass(spriteObj);
					break;
				
				case "bottomStripClass":
					bottomStripObj.setClass(spriteObj);
					break;
				
				case "onscreenActionCls":
					onscreenObj.setClass(spriteObj, assetFolder);
					break;
				
				case "keyboardClass":
					//keyboardObj.setClass(spriteObj);
					break;
				
				case "rounderIconClass":
					//rounderIconObj.setClass(spriteObj);
					break;
				
				case "rounderCls":
					//rounderObj.setClass(spriteObj);
					break;
				
				case "angleIconClass":
					//angleObj.setClass(spriteObj);
					break;
				
				case "headerClass":
					headerObj.setClass(spriteObj);
					break;
				
				case "exitDialogClass":
					exitDialogObj.setClass(spriteObj);
					break;
				
				case "bufferLoaderClass":
					bufferObj.setClass(spriteObj);
					break;
				
				case "displayModeBtnClass":
					//displayModeBtn.setClass(spriteObj);
					break;
				
				case "maskIconClass":
					//this.maskIconObj.setClass(spriteObj);
					break;
				
				case "exitIconClass":
					//this.exitIconObj.setClass(spriteObj);
					break;
			
				case "maskClass":
					//this.maskObj.setClass(spriteObj);
				break;
				
				case "blankareaClass":
					//this.blankAreaObj.setClass(spriteObj);
				break;				
			}
		}
		// Set Classes Area Ends...............
		public function launchStructure(id:Number):void
		{
			updateText("launchStructure::id::"+ id);
			bufferLoadStart();
			SoundMixer.stopAll();
			headerObj.setHeader(headerStr);
			//this.onhideTool();
			this.onHideToolBox();
			this.hideGeometricObjects();
			videoObj.clearVideo();
			swfObj.clearVideo();
			onscreenObj.clearAllButton();
			onscreenObj.clearMC();
			structureId = id;
			scrubObj.clearEnterFrame();
			try
			{
				//bgSegmentObj.setTime(0, 0);
				//bgSegmentObj.showHideTimer(false);
			}
			catch(e:Error)
			{
				
			}
			
			model.contentPath = structureArray[id].supportingFile;
			actionStarted = false;
			if (structureArray[id].type == "flv")
			{
				videoObj.setVideo(structureArray[id].url + "" + structureArray[id].name, structureArray[id].action, structureArray[id].customnav, structureArray[id].encryption, structureArray[id].x, structureArray[id].y, structureArray[id].width, structureArray[id].height,  structureArray[id].bgColor, structureArray[id].scale);
			}
			else
			{
				stageRef.executes("segmentBegins",structureArray[structureId].id);
				updateText("displayName: " + structureArray[id].displayName + " \n");
				model.stageRef.dispatchEvent(new DataEvent("NUGGET_PLAYER_FILE_LOAD", true, false, structureArray[id].name + "::" + structureArray[id].displayName));
				//swfObj.setVideo(structureArray[id].url + "" + structureArray[id].name, structureArray[id].action, structureArray[id].customnav, structureArray[id].x, structureArray[id].y, structureArray[id].width, structureArray[id].height,  structureArray[id].bgColor, structureArray[id].scale, structureArray[id].displayName);
				//swfObj.setVideo(model.homePath + structureArray[id].url, structureArray[id].action, structureArray[id].customnav, structureArray[id].x, structureArray[id].y, structureArray[id].width, structureArray[id].height,  structureArray[id].bgColor, structureArray[id].scale, structureArray[id].displayName);
				
				//converting millisecond to frame no.
				var frameNum:Number = Math.floor((structureArray[id].startAt / 1000)*PlayerModel.FRAME_RATE);
				autoPlayObj.hide(structureArray[id].isCompleted);
				swfObj.setVideo(structureArray[id].url, structureArray[id].action, structureArray[id].customnav, structureArray[id].x, structureArray[id].y, structureArray[id].width, structureArray[id].height,  structureArray[id].bgColor, structureArray[id].scale, structureArray[id].displayName, frameNum, structureArray[id].totalTime);
			}
			
			//id sent to sectionListClass
			try
			{
				sectionListObj.setCurSegment(structureId);
			}
			catch (e:Error)
			{
				updateText("sectionListObj not found...");
			}
			
			//////////////////////////////
			try
			{
				//explainObj.setCurSegment(structureId);
			}
			catch (e:Error)
			{
				updateText("explainObj not found...");
			}
			try
			{
				//exploreObj.setCurSegment(structureId);
			}
			catch (e:Error)
			{
				updateText("exploreObj not found...");
			}
			try
			{
				//evaluateObj.setCurSegment(structureId);
			}
			catch (e:Error)
			{
				updateText("evaluateObj not found...");
			}
			try
			{
				onscreenObj.clearAllButton();
			}
			catch (e:Error)
			{
				updateText("onscreenObj not found...");
			}
			try
			{
				// bgSegmentObj.setSegment(id, structureArray[id].displayName);
			}
			catch (e:Error)
			{
				updateText("bgSegmentObj not found...");
			}
		}
		
		public function showHideTimerTextField(b:Boolean):void {
			try
			{
				//bgSegmentObj.showHideTimerTextField(b);
			}
			catch (e:Error)
			{
				
			}
			
		}
		
		public function getElements():Array
		{
			return elementArray;
		}
		
		public function getSubElements():Array
		{
			return subElementArray;
		}
		
		public function getTotalVideoTime():String
		{
			return totalVideoTime;
		}
		
		public function getPlayerLanguage() :String 
		{
				
			if (assetFolder.lastIndexOf("hindinuggetplayer")!=-1) {				
				playerLanguage="hindi"
				
			}else {
				playerLanguage="english"
			}
			updateText("PLAYER LANGAUGE  >>  " +playerLanguage)	
			return playerLanguage
		}
		//=============================================
		// Print Job ==========================
		/*public function printJob():Bitmap
		{			
			var bm:Bitmap;
			
			if (structureArray[structureId].type == "flv")
			{
				bm = new Bitmap(videoObj.getScreenShot());
			}
			else
			{
				bm = new Bitmap(swfObj.getScreenShot());
			}
			
			var sp:Sprite = new Sprite();
			sp.addChild(bm);
			sp.scaleX = sp.scaleY = 0.55;
			model.stageRef.addChild(sp);
			var pj:PrintJob = new PrintJob();
			
			if (pj.start()) {  
                
					updateText("sp.width: " + sp.width + " | sp.height: " + sp.height);
                    pj.addPage(sp, new Rectangle(0, 0, 1024, 668)); 
               
                pj.send(); 
            } 
            else 
            { 
             
            } 
			model.stageRef.removeChild(sp);
		}*/
		
		
		
		
		//=============================================
		// Snap Shot Actions==========================
		public function getScreenShot():Bitmap
		{
			var shotBitmapData:BitmapData = new BitmapData(model.playerWidth, model.playerHeight, true, 0x00000000);
			var screenshot:Bitmap;
			if (structureArray[structureId].type == "flv")
			{
				shotBitmapData.draw(videoObj.getScreenShot());
			}
			else
			{
				shotBitmapData.draw(swfObj.getScreenShot());
			}
			//shotBitmapData.draw(drawAreaObj.getScreenShot());
			screenshot = new Bitmap(shotBitmapData);
			return screenshot;
		}
		
		public function showCapturedImage(bmp:Bitmap):void
		{
			if (structureArray[structureId].type == "flv")
			{
				videoObj.showCapturedImage(bmp);
			}
			else
			{
				swfObj.showCapturedImage(bmp);
			}
		}
		
		public function removeCapturedImage():void
		{
			if (structureArray[structureId].type == "flv")
			{
				videoObj.removeCapturedImage();
			}
			else
			{
				swfObj.removeCapturedImage();
			}
		}
		
		public function setListVisible():void
		{
			//snapShotObj.setVisible();
		}
		
		// Video functions ============================
		public function onVideoStart():void
		{
			scrubObj.startFn(Math.floor(swfObj.videoObj.totalFrames/30));
			updateText("PLAYER LANGAUGE  >>  " +Math.floor(swfObj.videoObj.totalFrames/30));	

			setScrubEnabled(true);
			setPlayPauseEnabled(true);
			playObj.setVisible(false);
			pauseObj.setVisible(true);
		}
		
		//=============================================
		//onscreenCls Actions==========================
		public function onVideoAction(obj:Object, refMc:MovieClip, type:String):void
		{
			actionStarted = true;
			onPause();
			onscreenObj.showButton(obj, refMc, type);
		}
		
		public function clearAllButton():void
		{
			onscreenObj.clearAllButton();
		}
		
		public function stopVideoAt(num:Number):void
		{
			if (structureArray[structureId].type != "flv")
			{
				swfObj.stopVideoAt(num);
			}
			else
			{
				videoObj.stopVideoAt(num);
			}
		}
		
		public function playVideoFrom(num:Number):void
		{
			if (structureArray[structureId].type != "flv")
			{
				swfObj.playVideoFrom(num);
			}
			else
			{
				videoObj.playVideoFrom(num);
			}
			onPlay();
		}
		
		//=============================================
		// Scrub functions ============================
		public function getPlayTime():Object
		{
			var obj:Object = new Object();
			if (structureArray[structureId].type == "flv")
			{
				obj = videoObj.getPlayTime();
				try
				{
					//bgSegmentObj.setTime(obj.currentframe, obj.totalframes);
					
				}
				catch(e:Error)
				{
					
				}
				return obj;
			}
			else
			{
				obj = swfObj.getPlayTime();
				try
				{
					//bgSegmentObj.setTime(obj.currentframe/24, obj.totalframes/24);
				}
				catch(e:Error)
				{
					
				}
				return obj;
			}
		}
		
		public function setPlayTime(tm:Number):void
		{
			if (structureArray[structureId].type == "flv")
			{
				videoObj.setPlayTime(tm);
			}
			else
			{
				swfObj.setPlayTime(tm);
			}
		}
		
		public function getByteLoaded():Number
		{
			if (structureArray[structureId].type == "flv")
			{
				return videoObj.getByteLoaded();
			}
			else
			{
				return swfObj.getByteLoaded();
			}
		}
		
		public function setScrubEnabled(bool:Boolean):void
		{
			if (structureArray[structureId].nav == "false")
			{
				bool = false;
			} else {
				//totalTimeObj.setTime(structureArray[structureId].totalTime);
			}
			updateText("scrubObj.setEnabled: " + bool);
			scrubObj.setEnabled(bool);
			totalTimeObj.setEnabled(bool);
			//bgSegmentObj.showHideTimer(bool);
			//bgSegmentObj.setTimer(bool);
		}
		
		public function nextStructureLoad():void
		{	
			stageRef.executes("segmentEnds", structureArray[structureId].id);
			if (structureArray[structureId + 1])
			{
				
				//if(checkAutoPlay() && model.previewMode) {
				if(checkAutoPlay()) {
					stageRef.executes("change", structureArray[structureId + 1].id);
					launchStructure(structureId + 1);				
				}
			}
			else
			{
				if (model.isExitOnLastSegment) {
					stageRef.executes("end");
					try
					{
						model.stageRef.dispatchEvent(new Event("NUGGET_PLAYER_EXIT", true, false));
						ExternalInterface.call("closeWin");
					}
					catch (e:Error)
					{
						fscommand("quit");
					}
				} else {
					onPause();
				}
			}
		}
		
		//=============================================
		// Play Pause functions =======================
		public function onPause():void
		{
			stageRef.executes("pause",structureArray[structureId].id);
			playObj.setVisible(true);
			pauseObj.setVisible(false);
			if (structureArray[structureId].type == "flv")
			{
				videoObj.setPause(true);
			}
			else
			{
				swfObj.setPause(true);
			}
		}
		
		public function onPlay():void
		{	
			stageRef.executes("play",structureArray[structureId].id);
			clearAllButton();
			playObj.setVisible(false);
			pauseObj.setVisible(true);
			if (structureArray[structureId].type == "flv")
			{
				videoObj.setPause(false);
			}
			else
			{
				swfObj.setPause(false);
			}
		}
		
		public function getPlayPauseStatus():Boolean
		{
			var bool:Boolean;
			if (structureArray[structureId].type == "flv")
			{
				bool = videoObj.getPlayPauseStatus();
			}
			else
			{
				bool = swfObj.getPlayPauseStatus();
			}
			return bool;
		}
		
		public function setPlayPauseEnabled(bool:Boolean):void
		{
			if (structureArray[structureId].nav == "false")
			{
				bool = false;
			}
			playObj.setEnabled(bool);
			pauseObj.setEnabled(bool);
			if (structureArray[structureId].type == "flv")
			{
				videoObj.enableDoubleClick(bool);
			}
			else
			{
				swfObj.enableDoubleClick(bool);
			}
		}
		
		//=============================================
		// Volume functions ===========================
		public function showVolume():void
		{
			volumeSliderObj.setVisible();
		}
		
		public function setVolumeFn(per:Number):void
		{
			updateText("per = " + per);
			soundVol = new SoundTransform(per)
			SoundMixer.soundTransform = soundVol;
			//videoObj.setVolmeFn(per);
			//swfObj.setVolmeFn(per);
			//model.soundVolume = soundVol.volume
			//updateText(model.soundVolume)
		}
		
		public function resetVolume():void {
			SoundMixer.soundTransform = soundVol;
		}
		
		public function muteVolume():void {
			SoundMixer.soundTransform = new SoundTransform(0)
		}
		
		//=============================================
		// Segment functions ===========================
		public function getSegments():Array
		{
			return structureArray;
		}
		
		//=============================================
		// Rounder functions ===========================
		public function changeRounderVisible():void
		{
			//var bool:Boolean = rounderObj.changeRounderVisible();
			try
			{
				//bgSegmentObj.setDistanceVisible(bool);
			}
			catch (e:Error)
			{
				
			}
		}
		
		//=============================================
		// Preloader functions ========================
		public function setPreloaderOnTop():void
		{
			preloadObj.setPreloaderOnTop();
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
		
		//=============================================
		// Flip functions =============================
		public function flipFn():void
		{
			//segmentObj.flipFn();
		}
		
		//=============================================
		// AutoPlay functions =============================
		public function checkAutoPlay():Boolean
		{
			return autoPlayObj.getAutoPlay();
		}
		
		//=============================================
		// Section List functions =====================
		public function showSectionList():void
		{
			//sectionListObj.showSectionList();
		}
		
		public function sectionOpened(bool:Boolean):void
		{
			sectionObj.sectionOpened(bool);
		}
		
		//=============================================
		// Angle Class functions =====================
		public function updateAngle(angle:Number):void
		{
			//labControlObj.updateAngle(angle);
		}
		
		public function setAngleVisible(bool:Boolean):void
		{
			//labControlObj.setAngleVisible(bool);
		}
		
		//=============================================
		// Angle Class functions =====================
		public function updateDistance(dist:String):void
		{
			try
			{
				//bgSegmentObj.updateDistance(dist);
			}
			catch (e:Error)
			{
				
			}
		}
		
		// Rounder Class functions =====================
		public function updateDistanceAngle(dist:String, angle:String):void
		{
			try
			{
				//bgSegmentObj.updateDistance(dist, angle);
			}
			catch (e:Error)
			{
				
			}
		}
		
		//=============================================
		public function setDistanceVisible(bool:Boolean):void
		{
			try
			{
				//bgSegmentObj.setDistanceVisible(bool);
			}
			catch (e:Error)
			{
				
			}
			try
			{
				//distanceToolObj.setDistanceVisible(bool);
			}
			catch (e:Error)
			{
				
			}
		}
		//=============================================
		
		//=============================================
		// on tool click ===== TOOLS ========================
		
		public function onToolClick():void {
			//this.toolboxObj.setVisible(true);
		}
		
		public function onHideToolBox():void {
			try
			{
				hideAllSubTools();
				//this.toolboxObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("toolboxObj not Found...");
			}
		}
		
		public function onToolLabClick():void {
			//toolboxLabObj.setVisible(true);
		}
		
		public function onHideToolLabBox():void {
			//toolboxLabObj.setVisible(false);
		}
		
		public function onhideTool():void {
			//Var.drawArea = this.drawAreaObj;
			
			try
			{
				//this.toolboxObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("toolboxObj not Found...");
			}
			try
			{
				//this.maskObj.setVisible(false);		
			}
			catch (e:Error)
			{
				//updateText("maskObj not Found...");
			}
			try
			{
				//this.scaletriaIconObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("scaletriaIconObj not Found...");
			}
			try
			{
				//this.scalecirIconObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("scalecirIconObj not Found...");
			}
			try
			{
				//this.scaledefaultIconObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("scaledefaultIconObj not Found...");
			}
			try
			{
				//this.scalecloseIconObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("scalecloseIconObj not Found...");
			}
			
			try
			{
				//this.pencursorObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("pencursorObj not Found...");
			}
			
			try
			{
				//this.erasecursorObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("pencursorObj not Found...");
			}
			try
			{
				//this.markercursorObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("markercursorObj not Found...");
			}
			//----
			try
			{
				//this.nextObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("nextObj not Found...");
			}
			try
			{
				//this.backObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("backObj not Found...");
			}
			try
			{
				//this.hidePagesObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("hidePagesObj not Found...");
			}
			try
			{
				//this.deletePageObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("deletePageObj not Found...");
			}
			try
			{
				//this.blankAreaObj.setVisible(false);
			}
			catch (e:Error)
			{
				//updateText("blankAreaObj not Found... !!!!!!!!!!!");
			}
			//
			this.onDrawAreaInitialise();
			this.hideAllSubTools();
		}
		
		private function onDrawAreaInitialise():void
		{
			try {
			//this.rectangleObj.drwaAreaInit();
			//this.circleObj.drwaAreaInit();
			//this.scaleObj.drwaAreaInit();
			//this.recprotectorObj.drwaAreaInit();
			//this.protectorObj.drwaAreaInit();
			} catch (e:Error) {
				updateText("Error in function onDrawAreaInitialise in controllerCls");
			}
		}
		
		public function clearSelection():void
		{
			//this.rectangleObj.clearSelection();
			//this.circleObj.clearSelection();
		}
		
		private function hideScaleOptions():void {
			this.onscaleCloseclk();
		}
		
		private function hideGeometricObjects():void {
			try
			{
				//this.rectangleObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("rectangleObj not Found...");
			}
			try
			{
				//this.circleObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("circleObj not Found...");
			}
			try
			{
				//this.protectorObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("protectorObj not Found...");
			}
			try
			{
				//this.recprotectorObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("recprotectorObj not Found...");
			}
			try
			{
				//this.scaleObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("scaleObj not Found...");
			}
		}
		
		//=============================================
		// on eraser icon click ========================
		public function eraseIconClk():void {
			this.hideAllSubTools();
			//this.drawSpr.removeEventListenertrue);
			//this.eraseallIconObj.setVisible(true);
			//this.erasepartIconObj.setVisible(true);
		}
		
		//=============================================
		// on pen icon click ========================
		public function onPenIconClick():void {
			this.hideAllSubTools();
			//this.defaultCursor();
			this.showPenOptions();
		}
		
		//=============================================
		// on scale icon click ========================
		public function scaleIconClick():void {
				try {
			this.hideAllSubTools();
			//this.drawSpr.removeEventListenerfalse);
			//this.scaletriaIconObj.setVisible(true);
			//this.scalecirIconObj.setVisible(true);
			//this.scaledefaultIconObj.setVisible(true);
			//this.scalecloseIconObj.setVisible(true);
				} catch (e:Error) {
					updateText("Error: scaleIconClick in controllercls");
				}
		}
		
		public function onscaleCloseclk():void {
			try {
			//this.scaletriaIconObj.setVisible(false);
			//this.scalecirIconObj.setVisible(false);
			//this.scaledefaultIconObj.setVisible(false);
			//this.scalecloseIconObj.setVisible(false);
			} catch (e:Error) {
				updateText("Error: onscalecloseclk in controllercls");
			}
		}
		
		//=============================================
		// on pen options and sub options click ========================
		public function onPenSelect():void {
			this.hidePenOptions();
			//this.drawAreaObj.selectedTool("pen");
			//this.pencursorObj.setVisible(true);
			//this.pencursorObj.customCursor();
			//this.maskObj.setVisible(false);	
		}
			
		private function showPenOptions():void {
			//this.pendefaultIconObj.setVisible(true);
			//this.penlineIconObj.setVisible(true);
			//this.pensquareIconObj.setVisible(true);
			//this.pencircleIconObj.setVisible(true);
		}
		
		private function hidePenOptions():void {
			try
			{
				updateText("hidePenOptions");
				//rectangleObj.setEnabled(false);
			}
			catch (e:Error)
			{
				updateText("rectangleObj not found");
			}
			try
			{
				//circleObj.setEnabled(false);
			}
			catch (e:Error)
			{
				
			}
			try
			{
				//this.pendefaultIconObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("pendefaultIconObj not found");
			}
			try
			{
				//this.penlineIconObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("penlineIconObj not found");
			}
			try
			{
				//this.pensquareIconObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("pensquareIconObj not found");
			}
			try
			{
				//this.pencircleIconObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("pencircleIconObj not found");
			}
			
		}
		
		public function onPenSquareClk():void {
			onArrowIconClk();
			this.hidePenOptions();
			//this.rectangleObj.setVisible(true);
			//rectangleObj.setEnabled(true);
			//rectangleObj.setType("square");
		}
		
		public function onPenCircleClk():void {
			onArrowIconClk();
			this.hidePenOptions();
			//this.rectangleObj.setVisible(true);
			//rectangleObj.setEnabled(true);
			//rectangleObj.setType("circle");
		}
		//=============================================
		// on erase btn select ========================
		
		public function onEraseSelect():void {
			this.hideAllSubTools();
			//this.drawAreaObj.selectedTool("erase");
			//erasecursorObj.customCursor();
			
			//this.maskObj.setVisible(false);	
		}
		
		public function onEraseAllClk():void {
			this.hideAllSubTools();
			//this.drawAreaObj.selectedTool("eraseAll");
			
			//this.maskObj.setVisible(false);	
			//this.recprotectorObj.setVisible(false);
			//this.rectangleObj.setVisible(false);
			//rectangleObj.clearAll();
			//this.circleObj.setVisible(false);
			//this.protectorObj.setVisible(false);
			//scaleObj.setVisible(false);
			//markerPlayerObj.setVisible(true);
			//erasePlayerObj.setVisible(false);
			onArrowIconClk();
			setDistanceVisible(false);
		}
		
		private function hideEraseOps():void {
			try
			{
				//this.eraseallIconObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("eraseallIconObj not Found...");
			}
			try
			{
				//this.erasepartIconObj.setVisible(false);
			}
			catch (e:Error)
			{
				updateText("erasepartIconObj not Found...");
			}
		}
		
		//=============================================
		// on line tool select ========================
		public function onLineSelect():void {
			this.hideAllSubTools();
			//this.drawAreaObj.selectedTool("line");
			//this.pencursorObj.setVisible(true);
			//this.pencursorObj.customCursor();
			//this.maskObj.setVisible(false);	
		}
		
		//=============================================
		// on scale tools select ========================
		public function onProtectorClk():void {
			onArrowIconClk()
			//this.protectorObj.setVisible(true);
			this.onscaleCloseclk();
			//this.maskObj.setVisible(false);	
		}
		public function onRecProtectorClk():void {
			onArrowIconClk()
			//this.recprotectorObj.setVisible(true);
			this.onscaleCloseclk();
			//this.maskObj.setVisible(false);	
			
		}
		public function onScaleClk():void {
			onArrowIconClk()
			this.defaultCursor();
			//this.scaleObj.setVisible(true);
			this.onscaleCloseclk();
			//this.maskObj.setVisible(false);	
		}
		
		//=============================================
		// on marker click ========================
		public function onMarkerClk():void {
			this.defaultCursor();
			this.hideAllSubTools();
			//this.drawAreaObj.selectedTool("marker");
			//this.maskObj.setVisible(false);	
			//markerPlayerObj.setVisible(false);
			//erasePlayerObj.setVisible(true);
			//markercursorObj.customCursor();
		}
		
		private function defaultCursor():void {
			//this.pencursorObj.changeDefaultCursor();
			//this.markercursorObj.changeDefaultCursor();
		}
		
		public function hidePenCursor(bool:Boolean):void
		{
			//pencursorObj.setVisible(bool);
		}
		
		public function hideMarkerCursor(bool:Boolean):void
		{
			//markercursorObj.setVisible(bool);
		}
		
		public function hideEraserCursor(bool:Boolean):void
		{
			//erasecursorObj.setVisible(bool);
		}
		
		public function onLineColorClk():void {
			
		}
		
		public function onMaskClk():void {
			this.defaultCursor();
			//this.maskObj.setVisible(true);
			this.hideAllSubTools();
		}
		
		//*---- added on 23rd aug----
		private function displayKey(keyEvent:KeyboardEvent):void {
			if (keyEvent.keyCode == 46) {
				this.removeObj();
			}
		}
		
		private function removeObj():void
		{
			/*
			switch(Var.objSelected) {
				case "square":
					//this.rectangleObj.setVisible(false)
				break;
				case "circle":
					//this.circleObj.setVisible(false)
				break;
				case "scale":
					//this.scaleObj.setVisible(false)
				break;
				case "rectProtector":
					//this.recprotectorObj.setVisible(false)
				break;
				case "protector":
					//this.protectorObj.setVisible(false)
				break;
			}
			Var.objSelected = "";
			*/
		}
		
		private function hideAllSubTools():void {
			this.hideEraseOps();
			this.hidePenOptions();
			this.hideScaleOptions();
			
		}
		
		private function onStgClk(e:MouseEvent):void {
			//this.hideAllSubTools();
			updateText("onStgClk: stage clicked... ")
		}
		
		/*
		 * on arrow clicked-----
		 * */
		public function onArrowIconClk():void {
			//this.drawAreaObj.selectedTool("arrow");
			//this.maskObj.setVisible(false);
			this.hideAllSubTools();
			defaultCursor();
			//markerPlayerObj.setVisible(true);
			//erasePlayerObj.setVisible(false);
			
			//this.drawSpr.removeEventListenerfalse);
			//this.drawAreaObj.nextBackPages();
		}
		
		/*
		 * on add,delete,nextback clk------
		 * */
		public function onAddPageClk():void {
			//this.nextObj.setVisible(true);
			//this.backObj.setVisible(true);
			this.hideAllSubTools();
			//this.drawSpr.removeEventListenerfalse);
			//this.drawAreaObj.selectedTool("addPage");
			//this.maskObj.setVisible(false);
			
			//
			//this.hidePagesObj.setVisible(true);
			//this.deletePageObj.setVisible(true);
		}
		
		public function onNextPageClk():void {
			//this.drawAreaObj.nextPagesCLk();
			onArrowIconClk();
		}
		
		public function onBackPageClk():void {
			//this.drawAreaObj.backPagesClk();
			onArrowIconClk();
		}
		
		public function hideBackArrow():void {
			//this.backObj.setVisible(false);
		}
		
		public function showBackArrow():void {
			//this.backObj.setVisible(true);
		}
		
		public function hideNextArrow():void {
			//this.nextObj.setVisible(false);
		}
		
		public function showNextArrow():void {
			//this.nextObj.setVisible(true);
		}
		
		public function enableBackArrow(bool:Boolean):void {
			//this.backObj.setEnabled(bool)
		}
		
		public function enableNextArrow(bool:Boolean):void {
			//this.nextObj.setEnabled(bool);
		}
		
		public function deletePageVisible(bool:Boolean): void
		{
			//deletePageObj.setEnabled(bool);
		}
		
		public function onHidePagesClk():void {
			//this.drawAreaObj.onHidePageClk();
			//this.nextObj.setVisible(false);
			//this.backObj.setVisible(false);
			//this.hidePagesObj.setVisible(false);
			//this.deletePageObj.setVisible(false);
			this.showHideVideoObj(false)
		}
		
		public function onDeletPageClk():void {
			onArrowIconClk();
			//this.drawAreaObj.delepePageClk();
		}
		
		public function onHidePageBtns():void {
			//this.nextObj.setVisible(false);
			//this.backObj.setVisible(false);
			//this.hidePagesObj.setVisible(false);
			//this.deletePageObj.setVisible(false);
		}
		
		public function showHideVideoObj(bool:Boolean):void {
			//this.blankAreaObj.setVisible(bool);
		}
		/*public function setDrawPageNum(num:Number):Number
		{
			//rectangleObj.setPageNum(num);
		}
		public function deleteRectangleObj(num:Number):Number
		{
			//rectangleObj.deletePage(num);
		}*/
		
		//*----
		//===== TOOLS ========================
		public function onPlayerExitClick():void
		{
			//On cliking exit button...
			exitDialogObj.setVisible(true);
		}
		
		public function bufferProgress(type:String, loaded:Number, total:Number):void
		{
			bufferObj.bufferProgress(type, loaded, total);
		}
		
		public function bufferLoadComplete():void
		{
			bufferObj.setVisible(false);
		}
		
		public function bufferLoadStart():void
		{
			bufferObj.setVisible(true);
		}
		
		//=======================================================
		public function toggleStopwatch():void
		{
			//stopWatchObj.toggleVisible();
		}
		
		public function toggleCalculator():void
		{
			//calculatorObj.toggleVisible();
		}

		public function updateMarkerColor(colorValue:String):void {
			//markerIconObj.updateMarkerColor(colorValue);
			//markerPlayerObj.updateMarkerColor(colorValue);
		}

		public function getPlayStatus():Boolean {
			return (!playObj.movRef.visible && playObj.movRef.hasEventListener(MouseEvent.CLICK));
		}
		
		public function displayMode(state:Boolean):void {
			mainRef.displayMode(state);
		}
		
		public function setHeaderCueName(value:String):void {
			headerObj.setHeaderCueName(value);
		}
		
		public function setSegmentTitle(value:String):void {
			headerObj.setSegmentTitle(value);
		}
		
		public function showHeaderCueName():void {
			headerObj.showCueName(model.showCue);
		}
		
		public function playerExit():void {
			updateText("playerExitHandler method called");
			stageRef.executes("exit",structureArray[structureId].id);
		}
		
		private function scrubChangeHandler(event:DataEvent):void {	
			//updateText("=================== scrubChangeHandler method called");
			totalTimeObj.setTime(Number(event.data), swfObj.videoObj.totalFrames/30);
		}
		
		public function dispose():void {
			swfObj.clearVideo();
		}
	}
}