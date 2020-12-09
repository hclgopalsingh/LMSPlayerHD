package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class autoPlayIconClass
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		private var model:PlayerModel;
		
		private var autoPlay:Boolean;
		
		public function autoPlayIconClass(sRef:Object)
		{
			superRef = sRef;
			autoPlay = true;
			
			model = PlayerModel.getInstance();
		}		
		public function setClass(mc:Object):void
		{
			movObj = mc;
			movRef = movObj.sprite;
			movObj.content.addEventListener(MouseEvent.CLICK, clickHandler);
			movObj.content.gotoAndStop(2);
			movRef.buttonMode = true;
			if (movObj.visible == "false")
			{
				movRef.visible = false;
			}
			
			/*if(model.previewMode || model.segmentList.length == 1) {
				movRef.visible = false;
				autoPlay = false;
			}*/
			
			if(model.previewMode) {
				movRef.visible = false; 
				autoPlay = false; 
			}
		}
		
		public function hide(value:Boolean):void {
			if(value == true) {
				movRef.visible = false;
				autoPlay = false;	
			} else {
				movRef.visible = true;
				autoPlay = true;
			}
		}
		
		private function clickHandler(e:MouseEvent):void
		{
			autoPlay = !autoPlay;
			if (autoPlay)
			{ 
				movObj.content.gotoAndStop(2);
			}
			else
			{
				movObj.content.gotoAndStop(1);
			}
		}
		
		public function getAutoPlay():Boolean
		{
			return autoPlay;
		}
	}
}