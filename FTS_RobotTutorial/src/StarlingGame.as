package
{
	import starling.display.Sprite;
	
	public class StarlingGame extends Sprite
	{
		public function StarlingGame()
		{
			super();
			var robot:Robot = new Robot();
			addChild(robot);
		}
	}
}