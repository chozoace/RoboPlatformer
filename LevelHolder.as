package 
{
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
	public class LevelHolder extends Sprite
	{
		public var _isAdded:Boolean = false;
		public var _tilesLoaded:Boolean = false;
		
		public function LevelHolder()
		{
			//this.height = 480;
			//this.width = 640;
		}
		
		public function getLevelHolder()
		{
			return this;
		}
	}
	
}