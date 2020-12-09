package
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class volumeClass
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		private var modelObj:PlayerModel;
		private var muted:Boolean;
		
		public function volumeClass(sRef:Object)
		{
			modelObj = PlayerModel.getInstance();
			superRef = sRef;
			muted = false;
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
			modelObj = PlayerModel.getInstance();
			modelObj.mainStage.addEventListener(CustomEvent.MUTE, setMute);
			modelObj.mainStage.addEventListener(CustomEvent.OPEN, setHighlight);
		}
		private function clickHandler(e:MouseEvent):void
		{
			superRef.showVolume();
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
		private function setMute(e:CustomEvent):void
		{
			
			muted = e.data.mute;
			trace("muted: " + muted);
			if (muted)
			{
				MovieClip(movObj.content).gotoAndStop(4);
			}
			else
			{
				MovieClip(movObj.content).gotoAndStop(2);
			}
		}
		private function setHighlight(e:CustomEvent):void
		{
			trace("setHighlight = " + e.data.open);
			if (e.data.open)
			{
				if (muted)
				{
					movObj.content.gotoAndStop(4);
				}
				else
				{
					movObj.content.gotoAndStop(2);
				}
			}
			else
			{
				if (muted)
				{
					movObj.content.gotoAndStop(3);
				}
				else
				{
					movObj.content.gotoAndStop(1);
				}
			}
		}
	}
}