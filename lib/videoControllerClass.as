package
{
	import flash.display.MovieClip;
	
	public class videoControllerClass
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		private var model:PlayerModel;
		
		public function videoControllerClass(sRef:Object)
		{
			superRef = sRef;			
			model = PlayerModel.getInstance();
		}		
		public function setClass(mc:Object):void
		{
			movObj = mc;
			movRef = movObj.sprite;
			
			//movObj.content.gotoAndStop(2);
			//movRef.buttonMode = true;
			movRef.mouseEnabled = false;
			 
			if (movObj.visible == "false")
			{
				movRef.visible = false;
			}
		}		
	}
}