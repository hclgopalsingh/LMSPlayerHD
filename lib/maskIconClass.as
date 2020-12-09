package
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class maskIconClass
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		
		public function maskIconClass(sRef:Object)
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
			trace("on mask icon clk")
			this.superRef.onMaskClk();
			e.stopImmediatePropagation();
			
		}
		public function setVisible(bool:Boolean):void
		{
			this.movRef.visible = bool;
		}
		public function setEnabled(bool:Boolean):void
		{
			this.movRef.buttonMode = bool;
			if (bool)
			{
				this.movRef.addEventListener(MouseEvent.CLICK, clickHandler);
			}
			else
			{
				this.movRef.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
		}
	}
}