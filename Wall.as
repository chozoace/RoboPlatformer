package 
{
	//import fl.controls.List;
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
	public class Wall extends Sprite
	{
		var _width:int;
		var _height:int;
		var _isVisible:Boolean = true;
		//var _posX:int;
		//var _posY:int;
		
		var _boundingBox:Rectangle;
		var _myClip:MovieClip;
		
		public function Wall(width:int, height:int, clipId:int = 0 , posX:int = 0, posY:int = 0)
		{
			_width = width;
			_height = height;
			//_isVisible = visible;
			this.x = posX;
			this.y = posY;
			Draw(clipId);
		}
		
		public function Draw(clipId:int):void
		{
			//_boundingBox = new Shape();
			if (clipId == 0)
			{
				if(_isVisible)
					this.graphics.beginFill(0xFFFFFF, 1); 
			}
				
			this.graphics.drawRect(0, 0, _width, _height);
			
			switch(clipId)
			{
				case 1:
					_myClip = new Tile1()
					this.addChild(_myClip);
					break;
				case 2:
					_myClip = new Tile2()
					this.addChild(_myClip);
					break;
				case 3:
					_myClip = new Tile3()
					this.addChild(_myClip);
					break;
				case 4:
					this.graphics.beginFill(0x000000, 1); 
					this.graphics.drawRect(0, 0, _width, _height);
					break;
				case 5:
					this.graphics.beginFill(0xFFFFFF, 1);
					this.graphics.drawRect(0, 0, _width, _height);
					break;
			}
		}
		
		public function interact():void
		{
			
		}
		
	}
	
}