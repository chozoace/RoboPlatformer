package 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
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
	public class LevelConstructor extends Sprite
	{
		public static var _instance:LevelConstructor;
		var _levelHolder:Sprite = new Sprite();
		var _levelOne:String = "XMLTest6.xml";
		var _levelTwo:String = "XMLTest5.xml";
		var _flash:String = "flash.xml";
		var _background:MovieClip = new Background1();
		var _backgroundHolder:Sprite = new Sprite();
		
		public function LevelConstructor()
		{
			_instance = this;
			var _tileBuild:TileCode = new TileCode();
		}
		
		public function CreateLevel(theLevel:String):void
		{
			//if (Main._instance._currentLevel > 1)
				//Main._instance.removeChild(_levelHolder);
			
			Main._instance.addChildAt(_levelHolder, 4);
			TileCode._instance.LoadMap(theLevel);
			if(theLevel == _levelOne)
				_levelHolder.x += 200;
		}
		
		public function Update():void
		{
			
		}
		
		public function Instance():LevelConstructor
		{
			return this;
		}
		
		public function GetLevelHolder():Sprite
		{
			return _levelHolder;
		}
		
		public function GetLevelWalls():DisplayObjectContainer
		{
			return DisplayObjectContainer(_levelHolder);
		}

	}
	
}