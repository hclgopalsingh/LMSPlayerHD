package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class sectionClass
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		
		public function sectionClass(sRef:Object)
		{
			superRef = sRef;
		}		
		public function setClass(mc:Object):void
		{
			//return;
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
			superRef.showSectionList();
		}
		public function sectionOpened(bool:Boolean):void
		{
			if (bool)
			{
				movObj.content.gotoAndStop(2);
			}
			else
			{
				movObj.content.gotoAndStop(1);
			}
		}
	}
}