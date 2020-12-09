package
{
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	import flash.external.*;
	
	public class headerClass
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		
		public function headerClass(sRef:Object):void
		{
			superRef = sRef;
		}
		public function setClass(mc:Object):void
		{
			movObj = mc;
			movRef = movObj.sprite;
			if (movObj.visible == "false")
			{
				movRef.visible = false;
			}
			
			superRef.showHeaderCueName();
		}
		public function setHeader(txt:String):void
		{
			try
			{
				movObj.content.head_txt_mc.head_txt.multiline = true;
				movObj.content.head_txt_mc.head_txt.wordWrap = true;
				movObj.content.head_txt_mc.head_txt.autoSize = TextFieldAutoSize.LEFT;
				if (superRef.getPlayerLanguage() == "hindi") {
					if (ExternalInterface.available) {
						trace("before header text: "+txt);
						//txt = ExternalInterface.call("convertText" , txt);
						trace("after header text: "+txt);
					}
				}
				movObj.content.head_txt_mc.head_txt.text = txt;
				/*if (movObj.content.head_txt_mc.height > 45) {
					movObj.content.head_txt_mc.y = movObj.content.head_txt_mc.y - 12;
				};*/
			}
			catch (e:Error)
			{
				
			}
		}
		
		public function setHeaderCueName(txt:String):void {
			try
			{					
				movObj.content.head_txt_mc.txtCueName.multiline = true;
				movObj.content.head_txt_mc.txtCueName.wordWrap = true;
				//movObj.content.head_txt_mc.txtCueName.autoSize = TextFieldAutoSize.LEFT;				
				movObj.content.head_txt_mc.txtCueName.text = txt;				
			}
			catch (e:Error)
			{
				
			}
		}
		
		public function setSegmentTitle(txt:String):void {
			try
			{					
				movObj.content.head_txt_mc.txtSegmentTitle.multiline = true;
				movObj.content.head_txt_mc.txtSegmentTitle.wordWrap = true;
				//movObj.content.head_txt_mc.txtCueName.autoSize = TextFieldAutoSize.LEFT;				
				movObj.content.head_txt_mc.txtSegmentTitle.text = txt;				
			}
			catch (e:Error)
			{
				
			}
		}
		
		public function showCueName(value:Boolean):void {
			movObj.content.head_txt_mc.txtCueName.visible = value;
		}
	}
}