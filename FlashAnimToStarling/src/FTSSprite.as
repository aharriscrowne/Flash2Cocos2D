package
{
	import starling.display.Sprite;
	
	public class FTSSprite extends Sprite
	{
		private var currentAnimationInfo:Array;
		private var currentCharacter:FTSCharacter;

		private var _spriteName:String;
		private var _ignoreRotation:Boolean;
		private var _ignorePosition:Boolean;
		private var _ignoreScale:Boolean;
		
		private var _animationsArr:Array;
		private var _depth:int;
		
		public function FTSSprite()
		{
			super();
			var __animations:Array = [];
			this.animationsArr = __animations;
		}
		
		public function get depth():int
		{
			return _depth;
		}

		public function set depth(value:int):void
		{
			_depth = value;
		}

		public function get spriteName():String
		{
			return _spriteName;
		}

		public function set spriteName(value:String):void
		{
			_spriteName = value;
		}

		public function get ignoreRotation():Boolean
		{
			return _ignoreRotation;
		}

		public function set ignoreRotation(value:Boolean):void
		{
			_ignoreRotation = value;
		}

		public function get ignorePosition():Boolean
		{
			return _ignorePosition;
		}

		public function set ignorePosition(value:Boolean):void
		{
			_ignorePosition = value;
		}

		public function get ignoreScale():Boolean
		{
			return _ignoreScale;
		}

		public function set ignoreScale(value:Boolean):void
		{
			_ignoreScale = value;
		}

		public function get animationsArr():Array
		{
			return _animationsArr;
		}

		public function set animationsArr(value:Array):void
		{
			_animationsArr = value;
		}

		public function playFrame(_frameindex:int):void
		{
			if (!currentAnimationInfo) return;
			if (_frameindex < currentAnimationInfo.length) 
				this.applyFrameInfo(currentAnimationInfo[_frameindex]);
		}
		
		public function setCurrentAnimation(_framesId:String, _character:FTSCharacter):void
		{
			currentCharacter = _character;
			currentAnimationInfo = this.animationsArr[_framesId];
		}
		
		private function setCurrentAnimationFramesInfo(_framesInfoArr:Array, _character:FTSCharacter):void
		{
			currentCharacter = _character;
			currentAnimationInfo = _framesInfoArr;
		}
		
		private function applyFrameInfo(_frameInfo: FTSFrameInfo):void
		{
			if (!ignorePosition){ 
				this.x = _frameInfo.x
				this.y = _frameInfo.y; 
			}
			
			if (!ignoreRotation){
				this.rotation = _frameInfo.rotation*Math.PI/180;
			}
			
			if (!ignoreScale) {
				if (_frameInfo.scaleX!=0)   this.scaleX = _frameInfo.scaleX;
				if (_frameInfo.scaleY!=0)   this.scaleY = _frameInfo.scaleY;
			}
		}
	}
}