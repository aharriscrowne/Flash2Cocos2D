package
{
	public class Robot extends FTSCharacter implements FTSCharacterDelegate
	{
		public function Robot()
		{
			this.delegate = this;
			this.visible = false;
			super("robot", "Robot/data");
			this.x = 100;
			this.y = 300;
		}
		
		public function onCharacterCreated(_character:FTSCharacter):void{
			this.playAnimation("static_move", false, true);
			this.visible = true;
			this.playAnimation("moving", true, true);
		}
		
		public function onCharacterEventAtFrame(_character:FTSCharacter, _event:String, _frameIndex:int):void{}
		public function onCharacterEndsAnimation(_character:FTSCharacter, _animationId:String):void{}
		public function onCharacterStartsAnimation(_character:FTSCharacter, _animationId:String):void{}
		public function onCharacterUpdateToFrame(_character:FTSCharacter, _frameIndex:int):void{}
		public function onCharacterLoopedAnimation(_character:FTSCharacter,  _animationId:String):void{}

	}
}