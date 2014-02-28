package
{
	public class FTSAnimationInfo
	{
		private var _name:String;
		private var _partName:String;
		private var _frameInfoArray:String;
		
		public function FTSAnimationInfo()
		{
		}

		public function get frameInfoArray():String
		{
			return _frameInfoArray;
		}

		public function set frameInfoArray(value:String):void
		{
			_frameInfoArray = value;
		}

		public function get partName():String
		{
			return _partName;
		}

		public function set partName(value:String):void
		{
			_partName = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

	}
}