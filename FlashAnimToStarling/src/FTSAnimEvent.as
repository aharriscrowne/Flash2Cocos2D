package
{
	public class FTSAnimEvent
	{
		private var _frameCount:int;
		private var _eventsInfo:Array;
		
		public function FTSAnimEvent()
		{
			var __eventsInfo:Array = [];
			this.eventsInfo = __eventsInfo;  
			__eventsInfo = null;
		}

		public function get frameCount():int
		{
			return _frameCount;
		}

		public function set frameCount(value:int):void
		{
			_frameCount = value;
		}

		public function get eventsInfo():Array
		{
			return _eventsInfo;
		}

		public function set eventsInfo(value:Array):void
		{
			_eventsInfo = value;
		}

	}
}