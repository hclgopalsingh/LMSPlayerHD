package
{

	import flash.events.Event;
	
	public class CustomEvent extends Event
	{
		private var _objData:Object;
		public static const ENTER:String = "enter";
		public static const MUTE:String = "mute";
		public static const OPEN:String = "open";
		
		public function CustomEvent(str:String, obj:Object):void
		{
			super(str)
			_objData = obj;
		}
		override public function clone():Event {
			var eventType:String = '';
		    if (this.type == CustomEvent.ENTER) {
				eventType = CustomEvent.ENTER;
			}if (this.type == CustomEvent.MUTE) {
				eventType = CustomEvent.MUTE;
			}if (this.type == CustomEvent.OPEN) {
				eventType = CustomEvent.OPEN;
			}
			//
			return new CustomEvent(eventType, _objData);
			
		}
		public function get data():Object
		{
			return _objData;
		}
	}

}