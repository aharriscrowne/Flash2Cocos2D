package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#222222")]
	public final class FTSTest extends Sprite
	{
		private var myStarling:Starling;
		
		public function FTSTest()
		{
			super();
			
			if (stage) start();
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function start():void
		{
			Starling.handleLostContext = true; // required on Windows, needs more memory

			this.stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var stageWidth:int = stage.stageWidth;
			var stageHeight:int = stage.stageHeight;
			
			myStarling = new Starling(StarlingGame, stage);
			myStarling.enableErrorChecking = Capabilities.isDebugger;
			myStarling.start();
		}
		
		private function onAddedToStage(event:Object):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			start();
		}
		

	}
}