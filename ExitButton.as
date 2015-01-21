package 
{
	import flash.display.MovieClip;
	import flash.system.fscommand;
	import flash.system.System;
	
	/**
	 * ...
	 * @author Roger
	 */
	public class ExitButton extends Button
	{
		
		public function ExitButton()
		{
			_myClip = new ExitButton_mc();
			this.addChild(_myClip);
			_myClip.gotoAndStop(1);
		}
		
		public function action()
		{
			if (Main._instance._pauseMenuState)
			{
				trace("cleared");
				Main._instance._pauseMenu._currentButton = 0;
				Main._instance.clearGame();
			}
			else
			{
				trace("exit program");
			}
		}
	}
	
}