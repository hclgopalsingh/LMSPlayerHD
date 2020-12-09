package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.fscommand;
	/**
	 * ...
	 * @author Mitr
	 */
	public class exitDialogClass 
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		private var playPauseStatus:Boolean;
		
		public function exitDialogClass(sRef:Object) 
		{
			this.superRef = sRef;
		}
		public function setClass(mc:Object):void
		{
			this.movObj = mc;
			this.movRef = this.movObj.sprite;
			movObj.content.yes_btn.addEventListener(MouseEvent.CLICK, exitYes);
			movObj.content.no_btn.addEventListener(MouseEvent.CLICK, exitNo);
			if (this.movObj.visible == "false")
			{
				this.movRef.visible = false;
			}
		}
		public function setVisible(bool:Boolean):void
		{
			movRef.visible = bool;
			if (bool) {
				playPauseStatus = superRef.getPlayStatus();
				//superRef.onPause();
			}
		}
		private function exitYes(e:MouseEvent):void
		{
			if(ExternalInterface.available) {
				try
				{
					var model:PlayerModel = PlayerModel.getInstance();
					//model.stageRef.dispatchEvent(new Event("NUGGET_PLAYER_EXIT", true, false));
					
					ExternalInterface.call("executes","exit");
					//model.stageRef.executes("exit");
				}
				catch (e:Error)
				{
					ExternalInterface.call("showAlert", e.errorID + "\n");
					//fscommand("quit");
				}
			}
		}
		private function exitNo(e:MouseEvent):void
		{
			setVisible(false);
			/*if (playPauseStatus)
			{
				superRef.onPlay();
			}
			else
			{
				superRef.onPause();
			}*/
		}
	}

}