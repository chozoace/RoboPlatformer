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
	public class LevelWall extends Wall 
	{
		public function LevelWall(width:int, height:int, clipId:int = 0 , posX:int = 0, posY:int = 0)
		{
			super(width, height, clipId);
			this.x = posX;
			this.y = posY;
		}
		
		override public function interact():void
		{
			if (!Main._instance._changingLevel)
			{
				Main._instance._player._controlsLocked = true;
				Main._instance._player._Xaccel = 0;
				Main._instance._player._backAccel = 0;
				Main._instance._player._speed = 0;
				Main._instance._player._backgroundSpeed = 0;
				Main._instance._player._YVelocity = 0;
				Main._instance.fadeDeathScreen("nextLevel");
			}
		}
	}
	
}