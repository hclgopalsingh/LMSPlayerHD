package
{
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class ScrollPanel extends MovieClip 	{
		
		
		private var _scrollButton:MovieClip;
		private var _scrollTrack:Sprite;
		private var _container:Sprite;
		private var _background:Sprite;
		private var _scroller:Sprite;
		private var _mask:Sprite;
		
		private var ScrollButton:Class;
		
		private var _rectangleX:uint = 0;
		private var _rectangleY:uint = 0;
		private var _rectangleW:uint = 0;
		private var _rectangleH:uint = 0;
		
		private var _content:*;
		
		private var _scrollType:String;
		
		
		public function set setBackgroundOpacity(value:Number):void {
			_background.alpha = value;
		}
		
		public function showHideScrollTrack(value:Boolean):void {
			_scrollTrack.visible = value;
			_scrollButton.visible = value;
		}
		
		public function set setScrollTrackOpacity(value:Number):void {
			_scrollTrack.alpha = value
		}
		
		
		private function clearPanel():void {
			try {	
				
				
				
				
				trace("check 3");
				removeChild(_background);
				trace("check 3.1");
				removeChild(_container);
				trace("check 4");
				removeChild(_scroller);
				trace("check 4.1");
				_scroller.removeChild(_scrollTrack);
				trace("check 4.2");
				_scroller.removeChild(_scrollButton);
				trace("check 4.3");			
				_scrollButton.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				trace("check 4.4");
				_container.removeChild(_content);
				trace("check 4.5");
				_scrollButton.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				trace("check 5");
				_scrollButton.removeEventListener(MouseEvent.MOUSE_MOVE, updatePosition);
				trace("check 5.1");
				_scrollButton.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				trace("check 5.2");
				_scrollButton.stage.removeEventListener(MouseEvent.MOUSE_MOVE, updatePosition);
				trace("check 5.3");
			} catch (e:Error) {}
		}
		
		public function ScrollPanel(content:*, ScrollButton:*, obj:Object, scrollType:String) {
			//clearPanel()
			_scrollType = scrollType;
			//this.alpha = 0.6;
			_scroller = new Sprite();
			
			_content = content;
			
			if (obj.isScrollButtonSource) {
				_scrollButton = obj.scrollButtonSource;
			} else {
				_scrollButton = ScrollButton;
			}
			
			
			_background = createRoundRect(obj.color, obj.rotation, obj.width, obj.height, obj.ellipseWidth, obj.ellipseHeight);
			
			
			if (obj.isScrollBarSource) {
				_scrollTrack = obj.scrollBarSource;
			} else {
				_scrollTrack = createRoundRect(obj.trackColor, obj.trackRotation, obj.trackWidth, obj.trackHeight, obj.trackEllipseWidth, obj.trackEllipseHeight);
			}
			
			
			_container = new Sprite();
			
			
			
			addChild(_background);			
			addChild(_container);
			
			addChild(_scroller);
			_scroller.addChild(_scrollTrack);
			_scroller.addChild(_scrollButton);
			_container.addChild(content);
			
			
			
			
			
			if(_scrollType == "Vertical") {
				_mask = createRoundRect(obj.color, obj.rotation, obj.width, obj.height-10, obj.ellipseWidth, obj.ellipseHeight);
				_mask.y = 5;
				_scroller.x = obj.width - _scrollTrack.width - 3;
				_rectangleX = _scrollButton.x;
				_rectangleY = _scrollButton.y;
				_rectangleW = 0;
				_rectangleH = _scrollTrack.height - _scrollButton.height;		
				if(_container.height < _background.height) {
					//_scrollButton.gotoAndStop(3);
					_scrollButton.enabled = false;
					trace("scroll button false");
				} else {
					_scrollButton.buttonMode = true;
					//_scrollButton.gotoAndStop(1);
					_scrollButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
					_scrollButton.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
					trace("scroll button true");
				}
			} else {
				_mask = createRoundRect(obj.color, obj.rotation, obj.width-10, obj.height, obj.ellipseWidth, obj.ellipseHeight);
				_mask.x = 5;
				_scroller.y = obj.height - _scroller.height;
				_rectangleX = _scrollButton.x;
				_rectangleY = _scrollButton.y;
				_rectangleW = _scrollTrack.width - _scrollButton.width;
				_rectangleH = 0;
				if(_container.width < _background.width) {
					_scrollButton.gotoAndStop(3);
					_scrollButton.enabled = false;
				} else {
					_scrollButton.buttonMode = true;
					_scrollButton.gotoAndStop(1);
					_scrollButton.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
					_scrollButton.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				}
			}
			addChild(_mask);
			_container.mask = _mask;
			
		}
		
		
		
		private function mouseDownHandler(evt:MouseEvent):void {
			_scrollButton.gotoAndStop(2);
			var rectangle:Rectangle = new Rectangle(_rectangleX, _rectangleY, _rectangleW, _rectangleH)			
			_scrollButton.startDrag(false, rectangle);
			_scrollButton.addEventListener(MouseEvent.MOUSE_MOVE, updatePosition);
			_scrollButton.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_scrollButton.stage.addEventListener(MouseEvent.MOUSE_MOVE, updatePosition);
		}
		
		private function updatePosition(evt:MouseEvent):void {
			var perc:uint, containerScroll:Number;
			if(_scrollType == "Vertical") {
				perc = (_scrollButton.y * 100)/(_rectangleH);
				containerScroll = _container.height - _mask.height;
				if(containerScroll > 0) {
					perc = (perc * containerScroll) / 100;
					_container.y = - perc;
				}
			} else {
				perc = (_scrollButton.x * 100)/(_rectangleW);
				containerScroll = _container.width - _mask.width;
				if(containerScroll > 0) {
					perc = (perc * containerScroll) / 100;
					_container.x = - perc;
				}
			}
			
		}
		
		private function mouseUpHandler(evt:MouseEvent):void {
			_scrollButton.gotoAndStop(1);
			_scrollButton.stopDrag();
			_scrollButton.removeEventListener(MouseEvent.MOUSE_MOVE, updatePosition);
			_scrollButton.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_scrollButton.stage.removeEventListener(MouseEvent.MOUSE_MOVE, updatePosition);
		}
		
		public function init():void {
			
		}
		
		private function createRoundRect(color:Array, rotation:Number, width:uint, height:uint, ellipseWidth:uint, ellipseHeight:uint):Sprite {
			var sp:Sprite = new Sprite();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(width, height, rotation);
			sp.graphics.beginGradientFill(GradientType.LINEAR,color,[1,1],[0,255],matrix);
			sp.graphics.drawRoundRect(0, 0, width, height, ellipseWidth, ellipseHeight);
			sp.graphics.endFill();
			return sp
		}
		
		
		
	}	
}