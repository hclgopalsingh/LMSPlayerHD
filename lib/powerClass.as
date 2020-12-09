package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class powerClass
	{
		private var superRef:Object;
		private var movObj:Object;
		private var movRef:MovieClip;
		
		
		public function powerClass(sRef:Object)
		{
			this.superRef = sRef;
		}
		public function setClass(mc:Object):void
		{
			this.movObj = mc;
			this.movRef = this.movObj.sprite;
			this.movRef.addEventListener(MouseEvent.CLICK, clickHandler);
			this.movRef.buttonMode = true;
			if (this.movObj.visible == "false")
			{
				this.movRef.visible = false;
			}
		}
		private function clickHandler(e:MouseEvent):void
		{
			superRef.onPlayerExitClick();
		}
	}
}