package 
{
	import fl.motion.Tweenables;
	import fl.transitions.TweenEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import fl.transitions.easing.Regular;
	import fl.transitions.Tween;
	
	/**
	 * ...
	 * @author Roger
	 */
	public class Main extends MovieClip
	{
		public static var _instance:Main;
		var _background:Background;
		var _player:Player;
		var _levelConstructor:LevelConstructor;
		var _pauseMenu:PauseMenu;
		var _mainMenu:MainMenu;
		var _blackScreen:MovieClip = new DeathScreen();
		var _wallList:Array = new Array();
		var _canKPress:Boolean = true;
		var _gameStarted:Boolean = false;
		var _currentLevel:int = 1;
		
		public static var _paused:Boolean = false;
		var _pauseMenuState:Boolean = false;
		var _mainMenuState:Boolean = false;
		var _changingLevel:Boolean = false;
		
		public function Main()
		{
			
			_instance = this;
			//Initialize();
			this.addEventListener(Event.ENTER_FRAME, Update);
			toMainMenu();
		}
		
		public function Instance():Main
		{
			return _instance;
		}
		
		public function toMainMenu():void//Intial Menu loading
		{
			_paused = true;
			_mainMenuState = true;
			_mainMenu = new MainMenu();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, CheckKeysDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, CheckKeysUp);
			this.addChild(_mainMenu);
			_mainMenu.createMainMenu();
			
			trace("mainMenu");
			
		}
		
		public function toMainMenu2():void//Opens up Main Menu
		{
			_paused = true;
			_mainMenuState = true;
			this.addChild(_mainMenu);
			var sample:Tween = new Tween( _mainMenu, "x", Regular.easeIn, -640, 0, 0.25, true);
			//stage.focus = _mainMenu;
			_mainMenu.createMainMenu();
		}
		
		public function fadeDeathScreen(event:String):void
		{
			this.addChild(_blackScreen);
			var blackScreenAlphaTween:Tween = new Tween ( _blackScreen, "alpha", Regular.easeIn, 0, 1, 0.5, true);
			//stage.focus = _blackScreen;
			if(event == "death")
				blackScreenAlphaTween.addEventListener(TweenEvent.MOTION_FINISH, onDeathScreenFinish, false, 0, true);
			else if (event == "nextLevel")
				blackScreenAlphaTween.addEventListener(TweenEvent.MOTION_FINISH, nextLevel, false, 0, true);
	
		}
		
		public function onDeathScreenFinish(event:TweenEvent):void
		{
			resetLevel();
			this.removeChild(_blackScreen);
		}
		
		public function Initialize()
		{
			_paused = false;
			var levelMade:Boolean = false;
			this.removeChild(_mainMenu);
			
			_background = new Background();
			_player = new Player();
			this.addChild(_player);
			_levelConstructor = new LevelConstructor();
			_levelConstructor.CreateLevel("LevelChange.xml");
			_pauseMenu = new PauseMenu();
			levelMade = true;
			_currentLevel = 1;
			
			this.addChild(_pauseMenu);
		}
		
		public function Update(event:Event):void
		{
			if (!_paused)
			{
				_player.Update();
				_background.Update();
				_levelConstructor.Update();
			}
			else if(_pauseMenuState)
			{
				_pauseMenu.Update();
			}
			if (_mainMenuState)
			{
				_mainMenu.Update();
			}
			
		}
		
		public function CheckKeysDown(keyState:KeyboardEvent)
		{
			if (keyState.keyCode == 80)//P
			{
				if (_canKPress)
				{
					if (!_paused)
					{
						_pauseMenuState = true;
						_pauseMenu._currentButton = 0;
						pause();
					}
					else
					{
						//_pauseMenuState = false;
						//unpause();
					}
				}
				_canKPress = false;
			}
			if (keyState.keyCode == 70)//F
			{
				
			}
		}
		
		public function CheckKeysUp(keyState:KeyboardEvent)
		{
			_canKPress = true;
		}
		
		public function pause():void
		{
			_paused = true;
			_player.pause();
			
			if(_pauseMenuState)
				_pauseMenu.createPauseMenu();
		}
		
		public function unpause():void
		{
			_paused = false;
			_player.unpause();
			
			if(!_pauseMenuState)
				_pauseMenu.removePauseMenu();
		}
		
		public function resetLevel():void
		{
			for (var i:int = 0; i < this.numChildren; i++)
			{
				trace(this.getChildAt(i));
			}
			
			this.removeChild(_player);
			_player = null;
			_player = new Player();
			this.addChildAt(_player, 3);
			
			LevelConstructor._instance.GetLevelHolder().x = 200;
			LevelConstructor._instance.GetLevelHolder().y = 0;
		}
		
		public function clearGame():void
		{
			_background.RemoveBackgrounds();
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			
			_pauseMenu = null;
			_player = null;
			_levelConstructor = null;
			_background = null;
			
			toMainMenu2();
			
			_paused = true;
			_pauseMenuState = false;
		}
		public function nextLevel(event:TweenEvent):void
		{
			_changingLevel = true;
			trace("next Level");
			_currentLevel++;
			this.removeChild(_player);
			_player = null;
			_player = new Player();
			this.addChildAt(_player, 3);
			this.removeChildAt(4);
			_levelConstructor = null;
			_levelConstructor = new LevelConstructor();
			
			if(_currentLevel == 2)
				_levelConstructor.CreateLevel("LevelChange2.xml");
			else if (_currentLevel == 3)
				_levelConstructor.CreateLevel("XMLTest7.xml");
			this.removeChild(_blackScreen);
			
			
			_changingLevel = false;
		}
		
	}
	
}