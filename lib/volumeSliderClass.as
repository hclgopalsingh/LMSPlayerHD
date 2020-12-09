package
{
	import com.greensock.TweenMax;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	
	public class volumeSliderClass
	{
		private var superRef:Object;
		private var movRef:MovieClip;
		private var movObj:Object;
		
		private var model:PlayerModel;
		
		private var maxY:Number;
		private var volumeVar:Number;
		
		public function volumeSliderClass(sRef:Object)
		{
			superRef = sRef;
			model = PlayerModel.getInstance();
			maxY = 55;
			volumeVar = 100;
		}		
		public function setClass(mc:Object):void
		{
			movObj = mc;
			movRef = movObj.sprite;
			if (movObj.visible == "false")
			{
				movRef.visible = false;
				movRef.alpha = 0;
				var blur:BlurFilter = new BlurFilter();
				blur.blurX = 90;
				blur.blurY = 90;
				movRef.filters = [blur];
			}
			movObj.content.muteMc.addEventListener(MouseEvent.CLICK, muteHandler);
			movObj.content.slider.draggerMc.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			movObj.content.slider.draggerMc.buttonMode = true;
		}
		private function muteHandler(e:MouseEvent):void
		{
			trace("Mute Clicked");
			//trace("movObj.content.muteMc.currentFrame : "+movObj.content.muteMc.currentFrame);
			var evt:CustomEvent;
			if (movObj.content.muteMc.currentFrame == 1)
			{
				
				movObj.content.muteMc.gotoAndStop(2);
				setVolumeFn(0);
				evt = new CustomEvent(CustomEvent.MUTE, { mute:true } );
			}
			else
			{
				
				movObj.content.muteMc.gotoAndStop(1);
				setVolumeFn(volumeVar);
				evt = new CustomEvent(CustomEvent.MUTE, { mute:false } );
			}
			model.mainStage.dispatchEvent(evt);
		}
		
		private function downHandler(e:MouseEvent):void
		{
			movObj.content.slider.draggerMc.startDrag(false, new Rectangle(0, 0, 0, maxY));
			movObj.content.slider.draggerMc.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			movObj.content.slider.draggerMc.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			model.mainStage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			model.mainStage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}
		private function upHandler(e:MouseEvent):void
		{
			movObj.content.slider.draggerMc.stopDrag();
			movObj.content.slider.draggerMc.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			movObj.content.slider.draggerMc.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			model.mainStage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			model.mainStage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}
		private function moveHandler(e:MouseEvent):void
		{
			var evt:CustomEvent;
			volumeVar = (100 - ((movObj.content.slider.draggerMc.y / maxY) * 100));
			setVolumeFn(volumeVar);
			if (volumeVar == 0)
			{
				movObj.content.muteMc.gotoAndStop(2);
				evt = new CustomEvent(CustomEvent.MUTE, { mute:true } );
			}
			else
			{
				movObj.content.muteMc.gotoAndStop(1);
				evt = new CustomEvent(CustomEvent.MUTE, { mute:false } );
			}
			model.mainStage.dispatchEvent(evt);
		}
		private function setVolumeFn(per:Number):void
		{
			superRef.setVolumeFn(per/100);
		}
		//==================================================================
		public function setVisible():void
		{
			var tweenMaxObj:TweenMax;
			var evt:CustomEvent;
			if (movRef.visible)
			{
				tweenMaxObj = TweenMax.to(movRef, 0.5, { alpha:0, onComplete:tweenComplete, blurFilter: { blurX:90, blurY:90 } } );
				model.stageRef.removeEventListener(MouseEvent.MOUSE_UP, offHandler);
				evt = new CustomEvent(CustomEvent.OPEN, { open:false } );
			}
			else
			{
				movRef.visible = true;
				tweenMaxObj = TweenMax.to(movRef, 0.5, { alpha:1, blurFilter: { blurX:0, blurY:0 } } );
				model.stageRef.addEventListener(MouseEvent.MOUSE_UP, offHandler);
				evt = new CustomEvent(CustomEvent.OPEN, { open:true } );
			}
			model.stageRef.dispatchEvent(evt);
		}
		private function tweenComplete():void
		{
			movRef.visible = false;
		}
		private function offHandler(e:MouseEvent):void
		{
			if (movRef.mouseX < 0 || movRef.mouseY < 0 || movRef.mouseX > movRef.width || movRef.mouseY > movRef.height)
			{
				setVisible();
			}
		}
	}
}