package 
{
	
	/**
	 * ...
	 * @author Roger
	 */
	public class StartButton extends Button 
	{
		public function StartButton()
		{
			_myClip = new StartButton_mc();
			this.addChild(_myClip);
			_myClip.gotoAndStop(1);
		}
		
		public function action()
		{
			Main._instance.Initialize();
			Main._instance._mainMenu.removeMainMenu();
		}
	}
	
}