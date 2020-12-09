package
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class playClass
	{
		private var superRef:Object;
		public var movRef:MovieClip;
		private var movObj:Object;
		
		public function playClass(sRef:Object)
		{
			superRef = sRef;
		}		
		public function setClass(mc:Object):void
		{
			movObj = mc;
			movRef = movObj.sprite;
			movRef.addEventListener(MouseEvent.CLICK, clickHandler);
			movRef.buttonMode = true;
			movObj.content.gotoAndStop(1);
			if (movObj.visible == "false")
			{
				movRef.visible = false;
			}
		}
		private function clickHandler(e:MouseEvent):void
		{
			superRef.onPlay();
		}
		public function setVisible(bool:Boolean):void
		{
			movRef.visible = bool;
		}
		public function setEnabled(bool:Boolean):void
		{
			movRef.buttonMode = bool;
			if (bool)
			{
				movRef.addEventListener(MouseEvent.CLICK, clickHandler);
				movObj.content.gotoAndStop(1);
			}
			else
			{
				movRef.removeEventListener(MouseEvent.CLICK, clickHandler);
				movObj.content.gotoAndStop(2);
			}
		}
	}
}