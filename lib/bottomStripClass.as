package
{
	import flash.display.MovieClip;
	
	public class bottomStripClass
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		
		public function bottomStripClass(sRef:Object)
		{
			this.superRef = sRef;
		}		
		public function setClass(mc:Object):void
		{
			this.movObj = mc;
			this.movRef = this.movObj.sprite;
			if (this.movObj.visible == "false")
			{
				this.movRef.visible = false;
			}
		}
	}
}