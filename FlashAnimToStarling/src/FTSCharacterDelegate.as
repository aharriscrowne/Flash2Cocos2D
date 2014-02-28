package
{
	public interface FTSCharacterDelegate
	{
		function onCharacterCreated(_character:FTSCharacter):void;
		function onCharacterEventAtFrame(_character:FTSCharacter, _event:String, _frameIndex:int):void;
		function onCharacterEndsAnimation(_character:FTSCharacter, _animationId:String):void;
		function onCharacterStartsAnimation(_character:FTSCharacter, _animationId:String):void;
		function onCharacterUpdateToFrame(_character:FTSCharacter, _frameIndex:int):void;
		function onCharacterLoopedAnimation(_character:FTSCharacter,  _animationId:String):void;

	}
}