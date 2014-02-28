package
{
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class FTSCharacter extends Sprite
	{
		
		private var currentAnimEvent:Array;
		
		private var intFrame:int;
		private var currentAnimationLength:int;
		
		private var currentAnimationId:String;
		private var nextAnimationId:String;
		
		private var _doesLoop:Boolean;
		private var nextAnimationDoesLoop:Boolean;
		private var _isPaused:Boolean;
		
		private var _delegate:FTSCharacterDelegate;
		private var _childrenTable:Array;
		private var _animationEventsTable:Array;
		
		public function FTSCharacter(_xmlFile:String, inDirectory:String="")
		{
			super();
			this.childrenTable = [];
			this.animationEventsTable = [];
			currentAnimationId = "";
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			this.createCharacterFromXML(_xmlFile, inDirectory);
		}
		
		private function scheduleUpdate():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function get delegate():FTSCharacterDelegate
		{
			return _delegate;
		}

		public function set delegate(value:FTSCharacterDelegate):void
		{
			_delegate = value;
		}

		public function get animationEventsTable():Array
		{
			return _animationEventsTable;
		}

		public function set animationEventsTable(value:Array):void
		{
			_animationEventsTable = value;
		}

		public function get childrenTable():Array
		{
			return _childrenTable;
		}

		public function set childrenTable(value:Array):void
		{
			_childrenTable = value;
		}

		public static function characterFromXMLFile(_xmlfile:String):FTSCharacter
		{
			var _c:FTSCharacter = new FTSCharacter(_xmlfile);
			return _c;
		}
		

		private function update(e:Event):void
		{
			if (currentAnimationLength == 0 || _isPaused) return;
			
			intFrame ++;
			
			
			// end of animation
			
			if (intFrame == currentAnimationLength) {
				
				if (!nextAnimationId == "") {            
					this.playAnimation(nextAnimationId, nextAnimationDoesLoop, false);
					return;
					
				} 
				
				if (!_doesLoop) {
					this.stopAnimation();
					return;            
				}
				
				intFrame = 0;
				this.delegate.onCharacterLoopedAnimation(this, currentAnimationId);
				
			}    
			
			this.playFrame();
			
		}
		
		public function playAnimation(_animId:String, _isLoopable:Boolean, _wait:Boolean):void
		{
			if (_wait && currentAnimationLength>0) {
				nextAnimationId = _animId;
				nextAnimationDoesLoop = _isLoopable;
				return;
			}
			
			_isPaused = false;
			
			nextAnimationId = "";
			nextAnimationDoesLoop = false;
			
			
			intFrame = 0;
			_doesLoop = _isLoopable;
			currentAnimationId = _animId;
			
			
			for each (var sprite:FTSSprite in this.childrenTable) {
				sprite.setCurrentAnimation(currentAnimationId, this);
			}       
			
			currentAnimEvent = FTSAnimEvent(this.animationEventsTable[_animId]).eventsInfo;
			currentAnimationLength = FTSAnimEvent(this.animationEventsTable[_animId]).frameCount;
			
			//    NSLog(@"PLAY ANIMATION - %@ CurrentAnimLength %i", _animId, currentAnimationLength);
			
			this.delegate.onCharacterStartsAnimation(this, _animId);
		}
		
		public function stopAnimation():void
		{
			currentAnimationLength = 0;
			var oldAnimId:String = currentAnimationId;
			currentAnimationId = "";

			this.delegate.onCharacterEndsAnimation(this, oldAnimId);
		}
		
		public function pauseAnimation():void
		{
			_isPaused = true;
		}
		
		public function resumeAnimation():void
		{
			_isPaused = false;
		}
		
		public function playFrameFromAnimation(_frameIndex:int, _animationId:String):void{
			trace("PLAYING FRAME "+ _frameIndex +" FROM "+ _animationId);
			currentAnimationId = _animationId;
			currentAnimEvent = FTSAnimEvent(this.animationEventsTable[_animationId]).eventsInfo;
			currentAnimationLength = FTSAnimEvent(this.animationEventsTable[_animationId]).frameCount;
			intFrame = _frameIndex;
			_isPaused = true;
			for each (var sprite:FTSSprite in this.childrenTable) {
				sprite.setCurrentAnimation(currentAnimationId, this);
			}   
			this.playFrame;
		}
		
		public function playFrame():void
		{
			if (currentAnimEvent[intFrame] != null) {
				this.delegate.onCharacterEventAtFrame(this, FTSEventInfo(currentAnimEvent[intFrame]).eventType, intFrame);
			};
				
			this.delegate.onCharacterUpdateToFrame(this, intFrame);
				
			for each (var sprite:FTSSprite in this.childrenTable) {        
				sprite.playFrame(intFrame);
			}
		}
		
		public function getCurrentAnimation():String
		{
			return currentAnimationId;
		}
		
		public function getDurationForAnimation(_animationId:String):int
		{
			return FTSAnimEvent(this.animationEventsTable[_animationId]).frameCount;
		}
		
		public function getFTSChildByName(_childName:String):FTSSprite
		{
			// build a predicate to look in the table what object has the propery _childname in .name
			return this.childrenTable[_childName] as FTSSprite;
		}
		
		public function getCurrentFrame():int
		{
			return intFrame;
		}
		
		public function addElement(_element:FTSSprite, _name:String, _index:int):void
		{
			this.addChild(_element);
			
			
			_element.name = _name;
			_element.depth = _index;
			
			this.childrenTable[_name] = _element;
		}
		
		public function reorderChildren():void
		{
			var totalChildren:int = this.childrenTable.length;
			this.childrenTable.filter(function(obj:FTSSprite, idx:int, array:Array):void {
				this.setChildIndex(obj, obj.depth);
			});			
		}
		
		// private
		public function setFirstPose():void
		{
			this.delegate.onCharacterCreated(this);
		}
		
		public function createCharacterFromXML(_xmlFile:String, inDirectory:String=""):void
		{
			var parser:FTSParser = new FTSParser();
			var success:Boolean = parser.parseXML(_xmlFile, this, inDirectory);
			if (!success) {
				trace("There was an error parsing "+_xmlFile);
			}
		}
	}
}