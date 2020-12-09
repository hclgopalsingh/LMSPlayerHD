package
{
	import flash.display.BlendMode;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class maskClass
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		
		private var startPoint:Point;
		private var eraserClip:Sprite = null;
		private var drawSpr:Sprite = null;
		private var myBitmapData:BitmapData = null
		private var myBitmap:Bitmap = null;
		
		public function maskClass(sRef:Object)
		{
			this.superRef = sRef;
		}		
		public function setClass(mc:Object):void
		{
			this.movObj = mc;
			this.movRef = this.movObj.sprite;
			
			this.addSprite();
			/*this.drawSpr.graphics.beginFill(0x000000);
			this.drawSpr.graphics.drawRect(0,0,1024,768);
			this.drawSpr.graphics.endFill();*/
			
			if (this.movObj.visible == "false")
			{
				this.movRef.visible = false;
			}
		}
		private function addSprite():void {
			this.drawSpr = new Sprite();
			this.movRef.addChild(this.drawSpr);
		}
		private function onMouDown(e:MouseEvent):void {
			resetSprite();
			this.eraserClip = new Sprite();
			this.drawSpr.addChild(this.eraserClip);
			this.myBitmapData = new BitmapData(1920, 1080, true, 0x000000);
			this.startPoint = new Point(this.movRef.mouseX, this.movRef.mouseY);
			this.movRef.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouMov);
		}
		private function onMouMov(e:MouseEvent):void {
			this.eraserClip.graphics.clear();
			this.eraserClip.graphics.lineStyle(2, 0x0000FF, 1);
			//this.eraserClip.graphics.beginFill(0xffffff, 1);
			var newx:int = this.drawSpr.mouseX;
			var newy:int = this.drawSpr.mouseY;
			var top:int = Math.min(newy, startPoint.y);
			var left:int = Math.min(newx, startPoint.x);
			var w:int = Math.abs(newx - startPoint.x);
			var h:int = Math.abs(newy - startPoint.y);
			this.eraserClip.graphics.drawRect(left, top, w, h);
			if (this.drawSpr.numChildren > 2) {
				this.drawSpr.removeChildAt(1);
				}
		}
		private function onMouUp(e:MouseEvent):void {
			eraserClip.graphics.clear();
			eraserClip.graphics.beginFill(0xffffff, 1);
			var newx:int = this.drawSpr.mouseX;
			var newy:int = this.drawSpr.mouseY;
			var top:int = Math.min(newy, startPoint.y);
			var left:int = Math.min(newx, startPoint.x);
			var w:int = Math.abs(newx - startPoint.x);
			var h:int = Math.abs(newy - startPoint.y);
			this.eraserClip.graphics.drawRect(left, top, w, h);
			this.drawSpr.graphics.beginFill(0x000000);
			this.drawSpr.graphics.drawRect(0,0,1920,1020);
			this.drawSpr.graphics.endFill();
			this.myBitmapData.draw(this.drawSpr , new Matrix(), null, BlendMode.NORMAL); 
			this.myBitmap = new Bitmap(myBitmapData); 
			this.movRef.removeChild(this.drawSpr);
			this.drawSpr = null;
			 
			this.movRef.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouMov);	
			
			this.maskIt()
		}
		private function maskIt():void {
			this.myBitmapData.draw(this.eraserClip, new Matrix(), null, BlendMode.ERASE);
			this.addSprite();
			this.drawSpr.addChild(this.myBitmap);
		}
		private function clickHandler(e:MouseEvent):void
		{
			//trace("kkkkkkkkkkkkk")
		}
		private function removeAllListener():void {
			if (this.movRef.hasEventListener(MouseEvent.MOUSE_DOWN)) {
				this.movRef.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouDown);
			}
			if (this.movRef.hasEventListener(MouseEvent.MOUSE_UP)) {
				this.movRef.removeEventListener(MouseEvent.MOUSE_UP,this.onMouUp);
			}
			if (this.movRef.hasEventListener(MouseEvent.MOUSE_MOVE)) {
				this.movRef.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouMov);
			}
		}
		public function setVisible(bool:Boolean):void
		{
			this.movRef.visible = bool;
			if (bool==false) {
				this.removeAllListener();
			}else {
				this.movRef.addEventListener(MouseEvent.CLICK, clickHandler);
				this.movRef.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouDown);
				this.movRef.addEventListener(MouseEvent.MOUSE_UP, this.onMouUp);
				this.resetSprite();
			}
		}
		
		private function resetSprite():void
		{
			trace(this.movRef.numChildren + " rrrrrrrrrrr " + this.drawSpr.numChildren)
			if (this.movRef.numChildren >= 2) {
				this.movRef.removeChild(this.drawSpr);
				this.addSprite();
				/*this.drawSpr.graphics.beginFill(0x000000);
				this.drawSpr.graphics.drawRect(0,0,1024,768);
				this.drawSpr.graphics.endFill();*/
			}
			
			
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