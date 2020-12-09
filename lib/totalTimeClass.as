package
{
	import flash.display.MovieClip;
	
	public class totalTimeClass
	{
		private var superRef:Object;
		public var movRef:MovieClip;
		private var movObj:Object;
		
		public function totalTimeClass(sRef:Object)
		{
			superRef = sRef;
		}		
		public function setClass(mc:Object):void
		{
			movObj = mc;
			movRef = movObj.sprite;			
			movRef.buttonMode = true;
			
			if (movObj.visible == "false")
			{
				movRef.visible = false;
			}
			
			//setTime(200);
		}
		
		public function setVisible(bool:Boolean):void
		{
			movRef.visible = bool;
		}
		public function setEnabled(bool:Boolean):void
		{
			if (bool)
			{
				movObj.content.txt.visible = true;
			}
			else
			{
				movObj.content.txt.visible = false;
			}
		}
		
		public function setTime(value:Number, totalTime:Number):void
		{			
			//superRef.updateText("totalTime::remainingTime::" + value + "::totalTime::"+totalTime);
			movObj.content.txt.text = UtilFunctions.convertToHHMMSS(Math.ceil(value)) + " / " + UtilFunctions.convertToHHMMSS(Math.floor(totalTime));
			//superRef.updateText("totalTime::" + movObj.content.txt.text);
			//setEnabled(false);
		}
		
	}
}