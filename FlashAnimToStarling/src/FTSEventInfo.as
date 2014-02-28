package
{
	public class FTSEventInfo
	{
		private var _frameIndex:int;
		private var _eventType:String;

		public function FTSEventInfo()
		{
		}

		public function get frameIndex():int
		{
			return _frameIndex;
		}

		public function set frameIndex(value:int):void
		{
			_frameIndex = value;
		}

		public function get eventType():String
		{
			return _eventType;
		}

		public function set eventType(value:String):void
		{
			_eventType = value;
		}

	}
}