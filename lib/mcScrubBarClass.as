package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class mcScrubBarClass extends Sprite
	{
		private var superRef:Object;
		private var stageRef:Object;
		private var mainStage:Object;
		private var movObj:Object;
		private var movRef:MovieClip;
		private var scrubPressed:Boolean;
		private var seenbarPosition:Number = 0;
		private var seekbarWidthFlag:Boolean = true;
		private var initX:Number;
		private var totalTime:Number;
		private var currentPosition:Number;
		private var scrubberThumbCircleHeight:Number;
		
		private var model:PlayerModel;
		
		public function mcScrubBarClass(sRef:Object)
		{
			model = PlayerModel.getInstance();
			superRef = sRef;
			stageRef = model.stageRef;
			mainStage = model.mainStage;
			
		}		
		public function setClass(mc:Object):void
		{
			movObj = mc;
			movRef = movObj.sprite;
			scrubPressed = false;
			if (movObj.visible == "false")
			{
				movRef.visible = false;
			} 
			
			movObj.content.mcScrub.txtCurrentPosition.visible = false;
			scrubberThumbCircleHeight = movObj.content.mcScrub.thumbCircle.height; 
			//superRef.updateText("widthConst = "+widthConst);
		}
		public function startFn(totalTime:Number):void
		{			
			try
			{
				this.totalTime = totalTime;
				movRef.addEventListener(Event.ENTER_FRAME, enterframeFn);
				movObj.content.clickBar.addEventListener(MouseEvent.CLICK, barClickFn);
				movObj.content.clickBar.buttonMode = true;
				movObj.content.mcScrub.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				movObj.content.mcScrub.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				movObj.content.mcScrub.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				movObj.content.mcSeenBar.width = movObj.content.mcScrub.x;
				currentPosition = 0;
				initX = 0;
				seenbarPosition = 0;			
			}
			catch(e:Error)
			{
				trace("No reference has been added to mcScrubBarClass...");
			}
		}
		private function enterframeFn(e:Event):void
		{
			movObj.content.mcBuffBar.width = (superRef.getByteLoaded() * movObj.content.mcSlideBar.width) / 100;
			movObj.content.clickBar.width = movObj.content.mcBuffBar.width;
			if (!scrubPressed)
			{
				var per:Number = (superRef.getPlayTime().currentframe / superRef.getPlayTime().totalframes) * 100;
				movObj.content.mcScrub.x = (per * (movObj.content.mcSlideBar.width)) / 100;
				if (superRef.getPlayTime().totalframes > 5 && per == 100)
				{
					superRef.onPause();
					superRef.nextStructureLoad();
				}
			}
			
			//movObj.content.mcSeenBar.width = movObj.content.mcScrub.x;
			
			if(model.forwardEnabled == false){
				if(movObj.content.mcSeenBar.width <= movObj.content.mcScrub.x){
					seekbarWidthFlag = true;	
				}
				if(seekbarWidthFlag == true){
					movObj.content.mcSeenBar.width = seenbarPosition;
				}
				if(movObj.content.mcScrub.x >= seenbarPosition){
					if(seekbarWidthFlag == true){
						movObj.content.mcSeenBar.width = movObj.content.mcScrub.x;
					}
				}}
			else
			{
				movObj.content.mcSeenBar.width = movObj.content.mcScrub.x;	
			}
			seekbarTimeHandler();
			if(currentPosition >= totalTime){				
				movObj.content.mcSeenBar.width = movObj.content.mcScrub.x;
			
			}
			
			var remTime:Number = totalTime-currentPosition;
			if(remTime < 0) {
				remTime = 0;
			}
			broadcastRemainingTime(remTime);
			
		}
		public function clearEnterFrame():void
		{
			
			movRef.removeEventListener(Event.ENTER_FRAME, enterframeFn);
		}
		
		private function onMouseDown(e:MouseEvent):void {
			scrubPressed = true;
			
			
			if(model.forwardEnabled == false){
				if(movObj.content.mcScrub.x >= seenbarPosition){				
					seenbarPosition = movObj.content.mcScrub.x;					
				}			
				//movRef.removeEventListener(Event.ENTER_FRAME, enterframeFn);
				e.currentTarget.startDrag(false, new Rectangle(0, scrubberThumbCircleHeight/2, movObj.content.mcSeenBar.width, 0));	
			}
			else{
				e.currentTarget.startDrag(false, new Rectangle(0, scrubberThumbCircleHeight/2, movObj.content.mcBuffBar.width, 0));	
			}
			
			movObj.content.mcScrub.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mainStage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent):void {
			movObj.content.mcScrub.stopDrag();
			mainStage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			superRef.setPlayTime((movObj.content.mcScrub.x / (movObj.content.mcSlideBar.width)) * 100);
			scrubPressed = false;
		}
		
		private function onMouseOver(e:MouseEvent):void {
			//superRef.updateText("currentPosition = ");
			this.addEventListener(Event.ENTER_FRAME, seekbarTimeHandler);
			movObj.content.mcScrub.txtCurrentPosition.visible = true;			
		}
		
		private function onMouseOut(e:MouseEvent):void {
			movObj.content.mcScrub.txtCurrentPosition.visible = false;
			this.removeEventListener(Event.ENTER_FRAME, seekbarTimeHandler);			
		}		
		
		private function seekbarTimeHandler(event:Event = null):void {
			currentPosition = Number((totalTime/(movObj.content.clickBar.width))*movObj.content.mcScrub.x);
			//superRef.updateText("currentPosition = "+currentPosition);
			movObj.content.mcScrub.txtCurrentPosition.text = UtilFunctions.convertToHHMMSS(Math.floor(currentPosition));
		}			
		
		public function setEnabled(bool:Boolean):void
		{
			if (bool)
			{
				//movRef.addEventListener(Event.ENTER_FRAME, enterframeFn);
				movObj.content.clickBar.addEventListener(MouseEvent.CLICK, barClickFn);
				movObj.content.clickBar.buttonMode = true;
				movObj.content.mcScrub.visible = true;
				movObj.content.mcSeenBar.visible = true;
				movObj.content.mcBuffBar.visible = true;
			}
			else
			{
				//clearEnterFrame();
				movObj.content.mcScrub.visible = false;
				movObj.content.mcSeenBar.visible = false;
				movObj.content.mcBuffBar.visible = false;
				movObj.content.clickBar.removeEventListener(MouseEvent.CLICK, barClickFn);
				movObj.content.clickBar.buttonMode = false;
			}
		}
		/*private function barClickFn(e:MouseEvent):void
		{
			trace("barClickFn = " + e.currentTarget.mouseX);
			superRef.setPlayTime((e.currentTarget.mouseX / movObj.content.mcSlideBar.width) * 100);
		}*/
		
		private function barClickFn(e:MouseEvent):void
		{
			initX = movObj.content.clickBar.mouseX;
			if(model.forwardEnabled == false){
				if(initX <= movObj.content.mcSeenBar.width)
				{
					seekbarWidthFlag = false;
					superRef.setPlayTime((e.currentTarget.mouseX / movObj.content.mcSlideBar.width) * 100);			
				}
			}
			else
			{
				superRef.setPlayTime((e.currentTarget.mouseX / movObj.content.mcSlideBar.width) * 100);	
			}
		}	
		
		private function broadcastRemainingTime(value:Number):void {
			dispatchEvent(new DataEvent(DataEvent.DATA, false, false, String(value)));
		}
		
	}
}