package 
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Fuck Al
	 */
	public class PauseMenu extends Menu 
	{
		var _menuAdded:Boolean = false;
		
		public function PauseMenu()
		{
			_myMenu = new PauseMenu_mc();
			
			_resumeButton.x = 50;
			_resumeButton.y = 250;
			_exitButton.x = 380;
			_exitButton.y = 250;
			
			_myButtons[0] = _resumeButton;
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
		
		public function CheckKeysDown(keyState:KeyboardEvent):void
		{
			if (Main._instance._pauseMenuState)
			{
				if (keyState.keyCode == 74)
				{
					trace(_currentButton);
					trace(_myButtons[_currentButton]);
					_myButtons[_currentButton].action();
					trace("from pause");
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
		
		public function CheckKeysUp(keyState:KeyboardEvent):void
		{
			
		}
		
		public function createPauseMenu():void
		{
			_visible = true;
			this.addChild(_myMenu);
			_resumeButton._selected = true;
			this.addChild(_resumeButton);
			this.addChild(_exitButton);
			_currentButton = 0;
			
			_resumeButton.Update();
			_exitButton.Update();
		}
		
		public function removePauseMenu():void
		{
			_visible = false;
			this.removeChild(_myMenu);
			this.removeChild(_resumeButton);
			this.removeChild(_exitButton);
		}
	}
	
}