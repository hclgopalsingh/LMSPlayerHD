package
{
	import flash.display.MovieClip;
	
	public class bufferLoaderClass
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		
		public function bufferLoaderClass(sRef:Object)
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
			movObj.content.perTxt.text = "";
		}
		public function setVisible(bool:Boolean):void
		{
			this.movRef.visible = bool;
		}
		public function bufferProgress(type:String, loaded:Number, total:Number):void
		{
			/*if (type == "bytes") {
				var per:Number = Math.round((loaded / total) * 100);
				movObj.content.perTxt.text = "l=" + loaded + "t=" + total + "%";
				if (per == 100)
				{
					//setVisible(false);
				}
			}			
			if (type == "stream") {
				setVisible(true);
				//movObj.content.perTxt.text = loaded + " sec(s)";
				movObj.content.perTxt.text = "";
				if (loaded >= total)
				{
					setVisible(false);
				}
			}*/
		}
	}
}