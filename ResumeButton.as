package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Roger
	 */
	public class ResumeButton extends Button
	{
		public function ResumeButton()
		{
			_myClip = new ResumeButton_mc();
			this.addChild(_myClip);
			_myClip.gotoAndStop(1);
		}
		
		public function action()
		{
			Main._instance._pauseMenuState = false;
			Main._instance.unpause();
		}
	}
	
}