package 
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Roger
	 */
	public class MainMenu extends Menu
	{
		var _menuAdded:Boolean = false;
		
		public function MainMenu()
		{
			_myMenu = new MainMenu_mc();
			
			_startButton.x = 50;
			_startButton.y = 250;
			_exitButton.x = 380;
			_exitButton.y = 250;
			
			_myButtons[0] = _startButton;
			_myButtons[1] = _exitButton;
		}
		
		public function Update():void
		{
			if (!_menuAdded)
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, CheckKeysDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, CheckKeysUp);
				_menuAdded = true;
			}
		}
		
		public function CheckKeysDown(keyState:KeyboardEvent)
		{
			if (Main._instance._mainMenuState)
			{
				if (keyState.keyCode == 74)
				{
					_myButtons[_currentButton].action();
					trace("from main");
				}
				if (keyState.keyCode == 68)//D:Right
				{
					if (_currentButton < _myButtons.length - 1)
					{
						_myButtons[_currentButton]._selected = false;
						_currentButton++;
						_myButtons[_currentButton]._selected = true;
						
						for (var i:int = 0; i < _myButtons.length; i++)
						{
							_myButtons[i].Update();
						}
					}
				}
				if (keyState.keyCode == 65)//A:Left
				{
					if (_currentButton > 0)
					{
						_myButtons[_currentButton]._selected = false;
						_currentButton--;
						_myButtons[_currentButton]._selected = true;
						
						for (var j:int = 0; j < _myButtons.length; j++)
						{
							_myButtons[j].Update();
						}
					}
				}
			}
		}
		
		public function CheckKeysUp(keyState:KeyboardEvent)
		{
			
		}
		
		public function createMainMenu():void
		{
			_visible = true;
			this.addChild(_myMenu);
			_startButton._selected = true;
			this.addChild(_startButton);
			this.addChild(_exitButton);
			
			_startButton.Update();
			_exitButton.Update();
		}
		
		public function removeMainMenu():void
		{
			_visible = false;
			this.removeChild(_myMenu);
			this.removeChild(_startButton);
			this.removeChild(_exitButton);
			Main._instance._mainMenuState = false;
		}
	}
	
}