package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.utils.AssetManager;
	
	public class FTSParser
	{

		private var _xmlMaster:XML;
		private var _hasSpriteSheet:Boolean;

		private var _assets:AssetManager;
		private var _character:FTSCharacter;
		private var _inDirectory:String;
		private var _xmlfile:String;
		
		public function FTSParser()
		{
			super();
		}
		
		public function parseXML(xmlfile:String, character:FTSCharacter, inDirectory:String=""):Boolean
		{
			_character = character;
			_inDirectory = inDirectory;
			_xmlfile = xmlfile;
			
			// sheets file
			this.parseSheetXML();
			
			//    [_character reorderChildren];
			
			// animations file
			
			return true;
		}
		
		public function parseSheetXML():void
		{
			var success:Boolean;
			var baseFile:String = _inDirectory + "/" + _xmlfile + "_sheets.xml";
			
			var myLoader:URLLoader = new URLLoader();
			myLoader.addEventListener(Event.COMPLETE, function(e):void{
				_xmlMaster = new XML(e.target.data);
				_assets = new AssetManager();
									
				if (!_xmlMaster) success = false;
				
				var _xmlString:String;
				var _imageString:String;
				for each (var _texturesheet:XML in _xmlMaster.TextureSheet){
					var sheetLoader:URLLoader = new URLLoader();
					sheetLoader.addEventListener(Event.COMPLETE, onSheetLoaded);
					
					sheetLoader.addEventListener(IOErrorEvent.IO_ERROR, onSheetLoadError);
					_xmlString = _inDirectory + "/" + _texturesheet.@name + ".xml";
					sheetLoader.load(new URLRequest(_xmlString));
				}

			});
			myLoader.load(new URLRequest(baseFile));
		}
		
		protected function onSheetLoadError(event:IOErrorEvent):void
		{
			_hasSpriteSheet = false;
			processSheet(false);
		}
		
		protected function onSheetLoaded(event:Event):void
		{
			_hasSpriteSheet = true;
			processSheet(true);
		}
		
		private function processSheet(dataLoaded:Boolean):void{
			
			for each (var _texture:XML in _xmlMaster..Texture)
			{
				var nName:String = _texture.@name;
				var NghostNameRange:int;
				NghostNameRange = nName.indexOf("ftsghost");
				if (NghostNameRange != -1) continue;
				
				
				var nAX:Number		= Number(_texture.@registrationPointX);
				var nAY:Number		= Number(_texture.@registrationPointY);
				var nImage:String	= _texture.@path;
				var zIndex:int		= int(_texture.@zIndex);
				
				if (dataLoaded){
					var _sprite:FTSSprite;
					
					//								if (textureSheetExists)
					_sprite = new FTSSprite();
					var textureImage:Image = new Image(_assets.getTexture(nImage.substr(0,nImage.lastIndexOf("."))));
					_sprite.addChild(textureImage);
					//								else 
					//								_sprite = [FTCSprite spriteWithFile:nImage];
					
					// SET ANCHOR P
					var eSize:Object = {width:_sprite.width, height:_sprite.height};
					var aP:Point = new Point(-nAX, -nAY);        
					textureImage.x = aP.x;
					textureImage.y = aP.y;
					
					_character.addElement(_sprite, nName, zIndex);
				}else{
					_assets.enqueue(_inDirectory + "/" + nImage);
				}
			}	
			
			if (!dataLoaded){
				_assets.loadQueue(function(ratio:Number):void{
					if (ratio==1.0){
						processSheet(true);

						_character.reorderChildren();
						
						parseAnimationXML();
					}
				});
			}

		}
		
		
		public function parseAnimationXML():void
		{
			var assets:AssetManager = new AssetManager();
			var baseFile:String = _inDirectory + "/" + _xmlfile + "_animations.xml";
			var _xmlMaster:XML;
			var myLoader:URLLoader = new URLLoader();
			myLoader.load(new URLRequest(baseFile));
			myLoader.addEventListener(Event.COMPLETE, function(e):void{
				_xmlMaster = new XML(e.target.data);

//				if (!_xmlMaster) success = false;
				
				for each (var _animation:XML in _xmlMaster.Animation)
				{
					// set the character animation (it will be filled with events)
					var animName:String = _animation.@name;
					if (animName == "") animName = "_init";
					
					for each (var _part:XML in _animation.Part){
						var partName:String = _part.@name;
						
						var ghostNameRange:int;
						ghostNameRange = partName.indexOf("ftcghost");
						if (ghostNameRange != -1) continue;
						
						var __partFrames:Array = [];
						var __sprite:FTSSprite = _character.childrenTable[partName];
						
						for each (var _frameInfo:XML in _part.Frame){
							var fi:FTSFrameInfo = new FTSFrameInfo();
							fi.index = int(_frameInfo.@index);
							fi.x = Number(_frameInfo.@x);
							fi.y = Number(_frameInfo.@y);
							fi.scaleX = Number(_frameInfo.@scaleX);                
							fi.scaleY = Number(_frameInfo.@scaleY);
							fi.rotation = Number(_frameInfo.@rotation);
							__partFrames.push(fi);
						}
						if (__sprite)
						__sprite.animationsArr[animName] = __partFrames;
					}
						
					
					// Process Events if needed
					var _animationLength:int = int(_animation.@frameCount);
					
					var __eventsArr:Array = new Array(_animationLength);
	//				for (var ea:int=0; ea<_animationLength; ea++) { __eventsArr.push(null);};
					
					
					for each (var _eventXML:XML in _animation.Marker){
						var eventType:String = _eventXML.@name;
						var frameIndex:int   = int(_eventXML.@frame);
						
						var _eventInfo:FTSEventInfo = new FTSEventInfo();
						_eventInfo.frameIndex = frameIndex;
						_eventInfo.eventType = eventType;
						
						__eventsArr.splice(frameIndex, 0, _eventInfo);
					}
					
					var __eventInfo:FTSAnimEvent = new FTSAnimEvent();
					__eventInfo.frameCount = _animationLength;            
					__eventInfo.eventsInfo = __eventsArr;
					
					_character.animationEventsTable[animName] = __eventInfo;
					
					
					__eventsArr = null;
					__eventInfo = null;
				}
				
				_character.setFirstPose();
			});
			
			

		}

	}
}