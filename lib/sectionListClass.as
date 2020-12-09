package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class sectionListClass
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		private var structureArray:Array;
		private var totalHeight:Number;
		private var currentHeight:Number;
		private var selectedId:Number;
		private var boxArray:Array;
		private var lineArray:Array;
		private var tweenMaxObj:TweenMax;
		private var fixedY:Number;
		private var sectionListMaxHeight:Number = 320;
		
		private var _scrollPanel:ScrollPanel;	
		
		private var _menuItemHolder:Sprite;
		
		
		private var model:PlayerModel;
		
		public function sectionListClass(sRef:Object)
		{
			superRef = sRef;
			model = PlayerModel.getInstance();
		}		
		public function setClass(mc:Object):void
		{	
			//return;
			movObj = mc;
			movRef = movObj.sprite;
			fixedY = movRef.y + 4;
			if (movObj.visible == "false")
			{
				movRef.visible = false;
				//movRef.alpha = 0;
				var blur:BlurFilter = new BlurFilter();
				blur.blurX = 10;
				blur.blurY = 10;
				movRef.filters = [blur];
			}
			structureArray = superRef.getSegments();
			createList();
		}
		private function createScrollPanel(sp:Sprite, x:uint, y:uint, w:uint, h:uint):ScrollPanel {
			
			var obj:Object = {};
			obj.color = [0x262626, 0x373737];
			obj.rotation = (90*Math.PI)/180;
			obj.width = w;
			obj.height = h;
			obj.ellipseWidth = 10;
			obj.ellipseHeight = 10;
			
			obj.trackColor = [0x262626, 0x262626];
			obj.trackRotation = (90*Math.PI)/180;
			obj.trackWidth = 20;
			obj.trackHeight = h;
			obj.trackEllipseWidth = 10; 
			obj.trackEllipseHeight = 10;
			obj.isScrollBarSource = true;
			var ScrollBar:Class=this.movObj.loader.contentLoaderInfo.applicationDomain.getDefinition("ScrollBar")  as  Class;
			obj.scrollBarSource = new ScrollBar();
			obj.scrollBarSource.name = "scrollBar";
			obj.scrollBarSource.mouseChildren = false;
			
			var scrollButton:MovieClip = new MovieClip();
			scrollButton.name = "scrollButton";
			scrollButton.graphics.beginFill(0xff0000, 1);
			scrollButton.graphics.drawCircle(9, 9, 10);
			scrollButton.graphics.endFill();
			obj.isScrollButtonSource = true;
			var ScrollButton:Class=this.movObj.loader.contentLoaderInfo.applicationDomain.getDefinition("ScrollButton")  as  Class;
			obj.scrollButtonSource = new ScrollButton();
			obj.scrollButtonSource.name = "scrollButton";
			obj.scrollButtonSource.mouseChildren = false;
			
			var scrollPanel:ScrollPanel = new ScrollPanel(sp, scrollButton, obj, "Vertical");
			scrollPanel.setBackgroundOpacity = 0;
			scrollPanel.setScrollTrackOpacity = 1;
			scrollPanel.x = x;
			scrollPanel.y = y;
			
			return scrollPanel;
			
		}
		private function createList():void
		{
			totalHeight = 0;
			currentHeight = 5;
			boxArray = new Array();
			lineArray = new Array();
			
			var txt:TextField;
			var runtimeClassRef:Class
			var runtimeLineRef:Class
			_menuItemHolder = new Sprite();
			for (var i:Number = 0; i < structureArray.length; i++)
			{
				/*
				if(model.displaySegmentList.length > 0) {
					for (var j:uint = 0; j < model.displaySegmentList.length; j++) {
						if (model.displaySegmentList[j] == (i + 1)) {
							txt = new TextField();
							runtimeClassRef = this.movObj.loader.contentLoaderInfo.applicationDomain.getDefinition("nugget_mc")  as  Class;
							runtimeLineRef = this.movObj.loader.contentLoaderInfo.applicationDomain.getDefinition("line_mc")  as  Class;
							lineArray[j] = new runtimeLineRef() as MovieClip;
							boxArray[j] = new runtimeClassRef() as Sprite;
							boxArray[j].name = i;
							boxArray[j].nugget_txt.autoSize = "left";
							boxArray[j].nugget_txt.text = structureArray[i].displayName;
							boxArray[j].bg_mc.height = boxArray[j].nugget_txt.height;
							boxArray[j].bg_mc.gotoAndStop(1);
							boxArray[j].y = currentHeight;
							currentHeight += boxArray[j].height + 10;
							lineArray[j].y = currentHeight-5;
							totalHeight = currentHeight;
							
							movRef.addChild(boxArray[j]);
							boxArray[j].addEventListener(MouseEvent.CLICK, onListClick);
							boxArray[j].addEventListener(MouseEvent.MOUSE_OVER, onListOver);
							boxArray[j].addEventListener(MouseEvent.MOUSE_OUT, onListOut);
							boxArray[j].mouseChildren = false;
							boxArray[j].buttonMode = true;
						}
					}
				} else {
				
					txt = new TextField();
					runtimeClassRef = this.movObj.loader.contentLoaderInfo.applicationDomain.getDefinition("nugget_mc")  as  Class;
					runtimeLineRef = this.movObj.loader.contentLoaderInfo.applicationDomain.getDefinition("line_mc")  as  Class;
					lineArray[i] = new runtimeLineRef() as MovieClip;
					boxArray[i] = new runtimeClassRef() as Sprite;
					boxArray[i].name = i;
					boxArray[i].nugget_txt.autoSize = "left";
					boxArray[i].nugget_txt.text = structureArray[i].displayName;
					boxArray[i].bg_mc.height = boxArray[i].nugget_txt.height;
					boxArray[i].bg_mc.gotoAndStop(1);
					boxArray[i].y = currentHeight;
					currentHeight += boxArray[i].height + 10;
					lineArray[i].y = currentHeight-5;
					totalHeight = currentHeight;
					
					movRef.addChild(boxArray[i]);
					boxArray[i].addEventListener(MouseEvent.CLICK, onListClick);
					boxArray[i].addEventListener(MouseEvent.MOUSE_OVER, onListOver);
					boxArray[i].addEventListener(MouseEvent.MOUSE_OUT, onListOut);
					boxArray[i].mouseChildren = false;
					boxArray[i].buttonMode = true;					
				}
				*/
				
				txt = new TextField();
				//runtimeClassRef = this.movObj.loader.contentLoaderInfo.applicationDomain.getDefinition("nugget_mc")  as  Class;
				runtimeClassRef = this.movObj.loader.contentLoaderInfo.
					//.applicationDomain.getDefinition("nugget_mc")  as  Class;
				runtimeLineRef = this.movObj.loader.contentLoaderInfo.applicationDomain.getDefinition("line_mc")  as  Class;
				lineArray[i] = new runtimeLineRef() as MovieClip;
				boxArray[i] = new runtimeClassRef() as Sprite;
				boxArray[i].name = i;
				boxArray[i].nugget_txt.autoSize = "left";
				boxArray[i].nugget_txt.text = structureArray[i].displayName;
				boxArray[i].bg_mc.height = boxArray[i].nugget_txt.height+8;
				boxArray[i].bg_mc.gotoAndStop(1);
				boxArray[i].y = currentHeight;
				currentHeight += boxArray[i].height + 10;
				lineArray[i].y = currentHeight-5;
				totalHeight = currentHeight;
				
				_menuItemHolder.addChild(boxArray[i]);
				boxArray[i].addEventListener(MouseEvent.CLICK, onListClick);
				boxArray[i].addEventListener(MouseEvent.MOUSE_OVER, onListOver);
				boxArray[i].addEventListener(MouseEvent.MOUSE_OUT, onListOut);
				boxArray[i].mouseChildren = false;
				boxArray[i].buttonMode = true;
				
				
			}
			if(totalHeight>sectionListMaxHeight) {
				_scrollPanel = createScrollPanel(_menuItemHolder, 0, 0, 473, sectionListMaxHeight+3);			
				movObj.content.mc.gotoAndStop(2);
				movObj.content.mainbg_mc.addChild(_scrollPanel);
			} else {
				movObj.content.mc.gotoAndStop(1);
				movObj.content.mainbg_mc.addChild(_menuItemHolder);
			}
			for (var y:Number = 0; y < lineArray.length; y++)
			{
				_menuItemHolder.addChild(lineArray[y]);
			}
			//alignment();
			drawRect();
			
			var header:MovieClip = movObj.content.mc as MovieClip;
		
			//movRef.content.setChildIndex(header, movObj.content.numChildren-1);
		}
		private function drawRect():void
		{
			var wid:Number = movObj.content.mc.width;
			var targ:Shape = new Shape();
			targ.graphics.clear();
			targ.graphics.lineStyle(1, 0x6A6A6A);
			targ.graphics.beginFill(0xFFFFFF, 1);
			if(totalHeight>sectionListMaxHeight) {
				targ.graphics.drawRect(0, 0, 450, sectionListMaxHeight+4);				
			} else {
				targ.graphics.drawRect(0, 0, wid, totalHeight);	
			}			
			targ.graphics.endFill();
			movObj.content.mainbg_mc.addChildAt(targ,0);
		}
		private function alignment():void
		{
			if(totalHeight>sectionListMaxHeight) {
				for (var i:Number = 0; i < _menuItemHolder.numChildren; i++)
				{
					_menuItemHolder.getChildAt(i).y -= sectionListMaxHeight;
				}
				_menuItemHolder.y = fixedY + totalHeight;		
			} else {
				for (i = 0; i < _menuItemHolder.numChildren; i++)
				{
					//_menuItemHolder.getChildAt(i).y -= totalHeight;
				}
				_menuItemHolder.y = fixedY + totalHeight;
			}
			
			drawRect();
		}
		private function onListClick(e:MouseEvent):void
		{
			superRef.launchStructure(Number(e.currentTarget.name));
			//offHandler(null)
		}
		private function onListOver(e:MouseEvent):void
		{
			e.currentTarget.bg_mc.gotoAndStop(2);
			var tFormat:TextFormat = new TextFormat();
			tFormat.color = 0x000000;
			e.currentTarget.nugget_txt.setTextFormat(tFormat);
		}
		private function onListOut(e:MouseEvent):void
		{
			if (e.currentTarget.name != boxArray[selectedId].name)
			{
				e.currentTarget.bg_mc.gotoAndStop(1);
				var tFormat:TextFormat = new TextFormat();
				tFormat.color = 0x000000;
				e.currentTarget.nugget_txt.setTextFormat(tFormat);
			}
		}
		public function setCurSegment(id:Number):void
		{
			/*
			if (model.displaySegmentList.length > 0) {
				for (var j:uint = 0; j < model.displaySegmentList.length; j++) {
					if (model.displaySegmentList[j] == (id+1)) {
						id = j;
						break;
					}
				}
			}
			*/
			
			selectedId = id;
			var tFormat:TextFormat = new TextFormat();
			tFormat.color = 0x000000;
			for (var i:Number = 0; i < boxArray.length; i++)
			{
				boxArray[i].bg_mc.gotoAndStop(1);
				boxArray[i].nugget_txt.setTextFormat(tFormat);
			}
			tFormat.color = 0x000000;
			boxArray[id].bg_mc.gotoAndStop(2);
			boxArray[id].nugget_txt.setTextFormat(tFormat);
		}
		public function showSectionList():void
		{
			var blur:BlurFilter = new BlurFilter();
			if (movRef.visible)
			{
				blur.blurX = 10;
				blur.blurY = 10;
				movRef.filters = [blur];
				tweenMaxObj = TweenMax.to(movRef, 0.5, { y:1080, ease:Expo.easeIn, onComplete:tweenComplete } );
				//tweenMaxObj = TweenMax.to(movRef, 0.5, { y:fixedY + totalHeight, ease:Expo.easeIn, onComplete:tweenComplete } );
				model.stageRef.removeEventListener(MouseEvent.MOUSE_DOWN, offHandler);
				superRef.sectionOpened(false);
			}
			else
			{
				movRef.visible = true;
				blur.blurX = 10;
				blur.blurY = 10;
				movRef.filters = [blur];
				if (totalHeight > 320) {
					trace("check height > " + totalHeight);
					//Changed by gopal to fix the section list posistion from "y:700" to "y:650"
					tweenMaxObj = TweenMax.to(movRef, 0.5, { y:665, ease:Expo.easeOut, onComplete:blurZero } );
				} else {
					trace("check height < " + totalHeight);
					//Changed by gopal to fix the section list posistion from "y:1080-totalHeight-60" to "y:1030-totalHeight-60"
					tweenMaxObj = TweenMax.to(movRef, 0.5, { y:1045-totalHeight-60, ease:Expo.easeOut, onComplete:blurZero } );
				}
				//tweenMaxObj = TweenMax.to(movRef, 0.5, { y:410, ease:Expo.easeOut, onComplete:blurZero } );
				model.stageRef.addEventListener(MouseEvent.MOUSE_DOWN, offHandler);
				superRef.sectionOpened(true);
			}
		}
		private function tweenComplete():void
		{
			movRef.visible = false;
		}
		private function blurZero():void
		{
			var blur:BlurFilter = new BlurFilter();
			blur.blurX = 0;
			blur.blurY = 0;
			movRef.filters = [blur];
			
		}
		private function offHandler(e:MouseEvent):void
		{
			if(e.target.name != "scrollButton" && e.target.name != "scrollBar") {
				showSectionList();
			}
		}
	}
}