package 
{
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Roger
	 */
	public class Menu extends Sprite
	{
		var _myMenu:MovieClip;
		var _myButtons:Array = new Array();
		var _visible:Boolean = false;
		var _currentButton:int = 0;
		
		var _resumeButton:MovieClip = new ResumeButton();
		var _exitButton:MovieClip = new ExitButton();
		var _startButton:MovieClip = new StartButton();
		
		public function Menu()
		{
			
		}
		
	}
	
	
}