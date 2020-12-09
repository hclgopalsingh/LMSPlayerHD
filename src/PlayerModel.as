package
{
	/**
	 * ...
	 * @author Mitr
	 */
	import flash.display.MovieClip;
	 
	public class PlayerModel extends MovieClip
	{
		public static var _instance:PlayerModel;
		private var _stageRef:Object;
		private var _width:Number;
		private var _height:Number;
		private var _kbdEvent:MovieClip
		
		private var _contentPath:String;
		private var _structurePath:String;
		private var _key:String;
		private var _displaySegmentList:Array = [];
		private var _isB2CDemo:Boolean = false;
		private var _host:String = "";
		private var _port:String = "";
		private var _isExitOnLastSegment:Boolean = true; // this we have introduce for shiksha
		private var _appStoragePath:String;
		private var _showCue:Boolean;
		
		//added by gopal
		private var _homePath:String;
		private var _segmentList:Array = [];
		private var _heading:String = "";
		private var _totalTime:String = "";
		private var _sessionId:String = "";
		private var _previewMode:Boolean = false;
		private var _forwardEnabled:Boolean = false;
		
		public static const LANG_HINDI:String = "Hindi";
		public static const LANG_ENGLISH:String = "English";
		public static const FRAME_RATE:Number = 30;
		
		private var _language:String = LANG_HINDI;	
		
		public static var pixelConversion:Number = 28.5;

		public var mainStage:Object;		
		
		
		public function get language():String
		{
			return _language;
		}
		
		public function get isExitOnLastSegment():Boolean
		{
			return _isExitOnLastSegment;
		}
		
		public function PlayerModel(obj:ModelEnforcer) 
		{
			trace('Base Model initiated');
			return;
		}

		public static function getInstance():PlayerModel
		{
			if( _instance == null ) _instance = new PlayerModel( new ModelEnforcer() );
			
			return _instance;
		}	
		
		public function set stageRef(_value:Object):void {
			if ( _stageRef == null) {
				_stageRef = _value;
			}
		}
		
		public function get stageRef():Object
		{
			return _stageRef;
		}	
		
		public function set playerWidth(_value:Number):void
		{
			_width = _value;
		}
		
		public function get playerWidth():Number
		{
			return _width;
		}	
		
		public function set playerHeight(_value:Number):void
		{
			_height = _value;
		}
		
		public function get playerHeight():Number
		{
			return _height;
		}
		public function set kbdEvent(_value:MovieClip):void
		{
			if (_kbdEvent == null)
			{
				_kbdEvent = _value;
			}
		}
		
		public function get kbdEvent():MovieClip
		{
			return _kbdEvent;
		}
		
		public function set contentPath(_value:String):void
		{
			_contentPath = _value;
		}
		
		public function get contentPath():String
		{
			return _contentPath;
		}
		
		public function set structurePath(_value:String):void
		{
			_structurePath = _value;
		}
		
		public function get structurePath():String
		{
			return _structurePath;
		}
		public function set key(_value:String):void
		{
			_key = _value;
		}
		
		public function get key():String
		{
			return _key;
		}	
		
		
		
		public function get displaySegmentList():Array 
		{
			return _displaySegmentList;
		}
		
		public function set displaySegmentList(value:Array):void 
		{
			_displaySegmentList = value;
		}
		
		public function get isB2CDemo():Boolean 
		{
			return _isB2CDemo;
		}
		
		public function get host():String 
		{
			return _host;
		}
		
		public function set host(value:String):void 
		{
			_host = value;
		}
		
		public function get port():String 
		{
			return _port;
		}
		
		public function set port(value:String):void 
		{
			_port = value;
		}
		
		public function get appStoragePath():String {
			return _appStoragePath;
		}
		
		public function set appStoragePath(value:String):void {
			_appStoragePath = value;
		}
		
		public function get showCue():Boolean {
			return _showCue;
		}
		
		public function set showCue(value:Boolean):void {
			_showCue = value;
		}

		public function get homePath():String
		{
			return _homePath;
		}

		public function set homePath(value:String):void
		{
			_homePath = value;
		}

		public function get segmentList():Array
		{
			return _segmentList;
		}

		public function set segmentList(value:Array):void
		{
			_segmentList = value;
		}

		public function get heading():String
		{
			return _heading;
		}

		public function set heading(value:String):void
		{
			_heading = value;
		}

		public function get totalTime():String
		{
			return _totalTime;
		}

		public function set totalTime(value:String):void
		{
			_totalTime = value;
		}

		public function get sessionId():String
		{
			return _sessionId;
		}

		public function set sessionId(value:String):void
		{
			_sessionId = value;
		}

		public function get previewMode():Boolean
		{
			return _previewMode;
		}

		public function set previewMode(value:Boolean):void
		{
			_previewMode = value;
		}

		public function get forwardEnabled():Boolean
		{
			return _forwardEnabled;
		}

		public function set forwardEnabled(value:Boolean):void
		{
			_forwardEnabled = value;
		}
	}

}
internal class ModelEnforcer{}