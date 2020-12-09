package
{
	import flash.display.MovieClip;
	import flash.display.Loader;
	public class preloaderCls
	{
		private var superRef:Object;
		private var stageRef:Object;
		private var movRef:MovieClip;
		
		private var swfObj:Object;
		
		private var model:PlayerModel;
		public function preloaderCls(sRef:Object):void
		{
			model = PlayerModel.getInstance();
			superRef = sRef;
			stageRef = model.stageRef;
		}
		public function init(path:String, swo:Object):void
		{
			swfObj = swo;
			swfObj.loadSWF(path, this);
		}
		public function swfLoaded(content:MovieClip, loader:Loader):void
		{
			superRef.updateText("preloaderCls::swfLoaded \n");
			movRef = content;
			stageRef.addChild(movRef);
			superRef.preloaderLoaded();
		}
		public function setPreloaderOnTop():void
		{
			stageRef.setChildIndex(movRef, stageRef.numChildren - 1);
		}
		public function clearPreLoader():void
		{
			superRef.updateText("preloaderCls::clearPreLoader \n");
			stageRef.removeChild(movRef);
		}		
	}
}