package 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Roger
	 */
	public class WholeLevel extends Sprite
	{
		public static var _instance:WholeLevel;
		
		public function WholeLevel()
		{
			_instance = this;
			//Main._instance.addChild(this);
		}
		
		public static function Instance():WholeLevel
		{
			return _instance;
		}
		
		public function getLevelRegion(x:int):DisplayObjectContainer
		{
			return DisplayObjectContainer(this.getChildAt(x));
		}
		
		public function relativeX():int
		{
			return this.x - 320;
		}
		
		public function relativeY():int
		{
			return this.y - 240;
		}
	}
	
}