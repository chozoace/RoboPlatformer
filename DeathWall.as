package 
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Roger
	 */
	public class DeathWall extends Wall 
	{
		public function DeathWall(width:int, height:int, clipId:int = 0 , posX:int = 0, posY:int = 0)
		{
			super(width, height, clipId);
			this.x = posX;
			this.y = posY;
		}
		
		override public function interact():void
		{
			if (!Main._instance._player._death)
			{
				Main._instance._player.Death();
			}
			//Main._instance.resetLevel();
		}
	}
	
}