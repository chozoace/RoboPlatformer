
package 
{
	import fl.transitions.Tween;
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
	import fl.transitions.easing.Regular;
	
	/**
	 * ...
	 * @author Roger
	 */
	public class Player extends Sprite
	{
		//////////
		//Sprite clips
		//////////
		var _myClip:MovieClip;//current sprite
		var _myDeathClip:MovieClip = new RoboDeathRight();
		var _rightIdle:MovieClip = new RoboIdleRight();
		var _leftIdle:MovieClip = new RoboIdleLeft();
		var _runRight:MovieClip = new RoboRunRight();
		var _runLeft:MovieClip = new RoboRunLeft();
		var _jumpRight:MovieClip = new RoboJumpRight();
		var _jumpLeft:MovieClip = new RoboJumpLeft();
		var _wallSlideLeft:MovieClip = new RoboSlideLeft();
		var _wallSlideRight:MovieClip = new RoboSlideRight();
		var _boostRight:MovieClip = new RoboBoostRight();
		var _boostLeft:MovieClip = new RoboBoostLeft();
		//var _deathRight:MovieClip = new RoboDeathRight();
		//////////
		//X Move variables
		//////////
		var _maxSpeed:int = 20;
		var _accelRate:Number = .8;
		var _decelRate:Number = 1.8;
		var _runningDecelRate:Number = 10;
		var _Xaccel:Number = 0;
		var _speed:Number = 0;
		var _maxBackSpeed:int = 10;
		var _backAccelRate:Number = .4;
		var _backDecelRate:Number = .9;
		var _runningBackDecelRate:Number = 5;
		var _backAccel:Number = 0;
		var _backgroundSpeed:Number = 0;
		var _keyState:KeyboardEvent;
		var _previousKeyState:KeyboardEvent;
		var _leftMove:Boolean = false;
		var _rightMove:Boolean = false;
		var _downMove:Boolean = false;
		var _upMove:Boolean = false;
		//////////
		//Sprite Control variables
		/////////
		var _canAnimChange:Boolean = true;
		var _isIdle:Boolean = true;
		var _facing:int = 0; //0 = right, 1 = left
		var _isMoving:Boolean = false;
		//////////
		//Previous check variables
		//////////
		var _prevX:Number;
		var _prevY:Number;
		var _prevYVelocity:Number;
		//////////
		//Jump variables
		//////////
		var _playerOnGround:Boolean;
		var _jumpSpeedLimit:int = 30;
		var _jumpSpeed:int = -18;
		var _wallJumpSpeed:int = -8;
		var _doubleJumpSpeed:int = -9;
		//////////
		//Gravity variables
		//////////
		var _gravity:Number = 1.5;
		var _YVelocity:Number = 0;
		var _canJump:Boolean = false;
		var _pressedJump:Boolean = false;
		//////////
		//Double jump variables
		//////////
		var _canDoubleJump:Boolean = true;
		var _jumpCount:int = 0;
		//////////
		//Key control variables
		//////////
		var _canJPress:Boolean = true;
		var _canUpPress:Boolean = true;
		var _canKPress:Boolean = true;
		var _eventListenersAdded:Boolean = false;
		//////////
		//Wall Jump variables
		//////////
		var _walljumpAccelRate:Number = 3;
		var _wallJumpMaxSpeed:int = 5;
		var _wallJumpGravity:int = 2;
		var _wallClingTimer:Timer = new Timer(700, 1);
		var _wallClingReleaseTimer:Timer = new Timer(200, 1);
		var _listenerCount:int = 0;
		var _postWallJump = false;
		var _canWallCling:Boolean = false;
		var _isWallClinged:Boolean = false;
		var _isWallJumping:Boolean = false;
		//////////
		//Boost Variables
		//////////
		var _boostTimer:Timer = new Timer(350, 1);
		var _boostBackSpeed:int = 20;
		var _boostSpeed:int = 35;
		var _isBoosting:Boolean = false;
		var _canAirBoost:Boolean = true;
		var _canBoost:Boolean = true;
		var _airBoost:Boolean = false;
		var _groundBoost:Boolean = false;
		//////////
		//Level holder variables
		//////////
		var _wallList:Array = new Array();
		var _levelHolder:Sprite;
		var _collidingBlock:DisplayObject;
		//////////
		//Collide box variables
		//////////
		var _rightCollideBox:Sprite;
		var _bottomCollideBox:Sprite;
		var _upperCollideBox:Sprite;
		var _leftCollideBox:Sprite;
		//////////
		//Collision control variables
		//////////
		var _XcollidingBlockDistance:int;
		var _collidingBlockDistance:int;
		var _newCollideY:int;
		var _newCollideX:int;
		var currentX:int;
		var currentY:int;
		var regionResult:int;
		//////////
		//Frame control variables
		//////////
		var _frameInt:Number = 0;
		var _deathInt:Number = 0;
		//////////
		//Pause variables
		//////////
		var _controlsLocked:Boolean = false;
		var _paused:Boolean = false;
		var _death:Boolean = false;

		public function Player()
		{
			_myClip = new RoboIdleRight();
			this.addChild( _myClip );	
			
			_myClip.stop();
			
			this.x = 320;
			this.y = 240;
			
			
			_rightCollideBox = new Sprite();
			this.addChild(_rightCollideBox);
			//_rightCollideBox.graphics.beginFill(0xFFFFFF, 1);
			_rightCollideBox.graphics.drawRect(50, 18, 10, 25);
			_bottomCollideBox = new Sprite();
			//_bottomCollideBox.graphics.beginFill(0xFFFFFF, 1);
			_bottomCollideBox.graphics.drawRect(16, 48, 16, 16);
			_upperCollideBox = new Sprite();
			this.addChild(_upperCollideBox);
			//_upperCollideBox.graphics.beginFill(0xFFFFFF, 1);
			_upperCollideBox.graphics.drawRect(16, 8, 16, 10);
			_leftCollideBox = new Sprite();
			this.addChild(_leftCollideBox);
			//_leftCollideBox.graphics.beginFill(0xFFFFFF, 1);
			_leftCollideBox.graphics.drawRect(0, 18, 10, 25);
			
			
			this.addChild(_bottomCollideBox);
		}
		
		public function Update():void
		{
			if (!_eventListenersAdded)
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, CheckKeysDown);
				stage.addEventListener(KeyboardEvent.KEY_UP, CheckKeysUp);
				_eventListenersAdded = true;
				
				clearInterval(_frameInt);
				_frameInt = setInterval(moveFrame, 90);
			}
			
			UpdateMovement();
		}
		
		public function UpdateMovement():void
		{
			_levelHolder = LevelConstructor._instance.GetLevelHolder();
			_newCollideX = this.x + 60;//for x collision can be moved
			
			//////////
			//X Movement
			//////////
			if (!_controlsLocked)
			{
				if (_leftMove && _isWallClinged == false && _isWallJumping == false && _rightMove == false && !_isBoosting)//Left Movement
				{
					_facing = 1;
					if(!_postWallJump)
						_Xaccel = _accelRate;
					else
						_Xaccel = _walljumpAccelRate;//makes me wall jump fast
					
						
					if (_canJump && _myClip != _runLeft)
					{
						_canAnimChange = true;
					}
					
					var _leftCollide:Boolean;
					
					_leftCollide = CheckCollision(_leftCollideBox);
						
					if (!_leftCollide)
					{
						_backAccel = _backAccelRate;
					}
					else
					{
						if (_canJump == false && _YVelocity >= -5)
						{
							_canWallCling = true;
							stopBoost2();
							WallCling();
						}
						else if (_postWallJump && !_canJump)
						{
							_canWallCling = true;
							WallCling();
						}
					}
				}
				
				if (_rightMove && _isWallClinged == false && _isWallJumping == false && _leftMove == false && !_isBoosting)//right movement
				{
					_facing = 0;
					if(!_postWallJump)
						_Xaccel = -_accelRate;
					else
						_Xaccel = -_walljumpAccelRate;
					
					if (_canJump && _myClip != _runRight)
					{
						_canAnimChange = true;
					}
					
					var _rightCollide:Boolean;
					
					_rightCollide = CheckCollision(_rightCollideBox);
					
					if (!_rightCollide)
					{
						_backAccel = -_backAccelRate;
					}
					else
					{
						if (_canJump == false && _YVelocity >= -5)
						{
							_canWallCling = true;
							stopBoost2();
							WallCling();
						}
						else if (_postWallJump && !_canJump)
						{
							_canWallCling = true;
							WallCling();
						}
					}
				}
			}
			//////////
			//Jumping code
			//////////
			if (!_controlsLocked)
			{
				if (_upMove && _canDoubleJump && !_isWallClinged) //jump starts here
				{
					_levelHolder.y -= _YVelocity;
					_YVelocity = _jumpSpeed;
					
					if (_facing == 0)
					{
						this.removeChild(_myClip);
						_myClip = _jumpRight;
						this.addChild(_myClip);
					}
					else if (_facing == 1)
					{
						this.removeChild(_myClip);
						_myClip = _jumpLeft;
						this.addChild(_myClip);
					}
					_upMove = false;
					_canAnimChange = false;
					_canJump = false;
					_pressedJump = true;
					_isIdle = false;
					
					if (_jumpCount >= 1)
					{
						_canDoubleJump = false;
					}
					else
						_jumpCount++;
				}
			}
			
			if (!CheckCollision(_bottomCollideBox) && _isWallClinged == false)//makes me fall
			{
				_canJump = false;
			}
			
			if (_canJump == false && _isWallClinged == false)//increases Yvelocity by gravity
				_YVelocity += _gravity;
				
			
			if (_YVelocity > _jumpSpeedLimit)//terminal velocity
				_YVelocity = _jumpSpeedLimit;	
			
			if (CheckCollision(_bottomCollideBox) && _canJump == false)//when i land on ground
			{	
						
				if(_YVelocity > 0)
				{
					_wallClingTimer.stop();
					if (_isWallJumping)
					{
						_rightMove = false;
						_leftMove = false;
					}
					_isBoosting = false;
					_canBoost = true;
					_isWallJumping = false;
					_isWallClinged = false;
					_canWallCling = false;
					_canJump = true;
					_canDoubleJump = true;
					_pressedJump = false;
					_jumpCount = 0;
					_postWallJump = false;
					_canAirBoost = true;
					
					_newCollideY = this.y + this.height;
					_levelHolder.y = _newCollideY - _collidingBlockDistance;
					
					if (_YVelocity > 2)
					{
						if (_isIdle && _facing == 0)
						{
							this.removeChild(_myClip);
							_myClip = _rightIdle;
							this.addChild(_myClip);
							_isIdle = true;
							_canAnimChange = true;
						}
						else if (_isIdle && _facing == 1)
						{
							this.removeChild(_myClip);
							_myClip = _leftIdle;
							this.addChild(_myClip);
							_isIdle = true;
							_canAnimChange = true;
						}
						else if (_leftMove || _speed > 0)
						{
							this.removeChild(_myClip);
							_myClip = _runLeft;
							this.addChild(_myClip);
							_isIdle = false;
							_canAnimChange = true;
						}
						else if (_rightMove || _speed < 0)
						{
							this.removeChild(_myClip);
							_myClip = _runRight;
							this.addChild(_myClip);
							_isIdle = false;
							_canAnimChange = true;
						}
					}
					_YVelocity = 0;
				}
			}
			
			if (CheckCollision(_upperCollideBox) && _canJump == false)//causes upper collision
			{
				_canDoubleJump = false;
				_YVelocity = _YVelocity * -1;
				_newCollideY = this.y - 32;
				_levelHolder.y = _newCollideY - _collidingBlockDistance;
			}
			
			if(_canJump == false && !_airBoost)//updates fall
			{
				_canAnimChange = true;
				_levelHolder.y -= _YVelocity;
				_jumpCount = 1;
				
				Background._instance._background1.y = _levelHolder.y;
				Background._instance._background2.y = _levelHolder.y;
				Background._instance._background3.y = _levelHolder.y;
				
				if (_canAnimChange && !_isWallClinged)//find a way to make this happen once
				{
					if (_facing == 0 && _pressedJump == false)
					{
						this.removeChild(_myClip);
						_myClip = _jumpRight;
						this.addChild(_myClip);
					}
					if (_facing == 1 && _pressedJump == false)
					{
						this.removeChild(_myClip);
						_myClip = _jumpLeft;
						this.addChild(_myClip);
					}
					_canAnimChange = false;
				}
			}
			//////////
			//Idle
			//////////
			if (!_leftMove && !_rightMove && !_upMove && !_downMove && _canJump && _speed == 0 && !_death)
			{
				if (!_isIdle && _canJump == true && _facing == 0)
				{
					this.removeChild(_myClip);
					_myClip = _rightIdle;
					this.addChild(_myClip);
					_isIdle = true;
					_canAnimChange = true;
					_isMoving = false;
				}
				else if (!_isIdle && _canJump == true && _facing == 1)
				{
					this.removeChild(_myClip);
					_myClip = _leftIdle;
					this.addChild(_myClip);
					_isIdle = true;
					_canAnimChange = true;
					_isMoving = false;
				}
				_canAnimChange = true;
			}
			//////////
			//Acceleration control
			//////////			
			if (_speed - 1 < _maxSpeed && _speed + 1 > -_maxSpeed)// increase speed by acceleration 
			{	
				if (_rightMove && !_leftMove)
				{
					
					if (_speed < _maxSpeed || _speed == 0)
						_speed += _Xaccel;
					else if (_speed > -_maxSpeed)
					{
						_speed -= _runningDecelRate;
					}
				}
				if (_leftMove && !_rightMove)
				{
					if (_speed > -_maxSpeed || _speed == 0)
						_speed += _Xaccel;
					else if (_speed < _maxSpeed)
					{
						_speed += _runningDecelRate;
					}
				}
				
			}
			else if (_speed > _maxSpeed && !_isBoosting)//speed control
				_speed = _maxSpeed;
				
			else if (_speed < -_maxSpeed && !_isBoosting)//speed control
				_speed = -_maxSpeed;
				
				
			if (_backgroundSpeed - 1 < _maxBackSpeed && _backgroundSpeed + 1 > -_maxBackSpeed)// increase speed by acceleration 
			{	
				if (_rightMove && !_leftMove)
				{
					if (_backgroundSpeed < _maxBackSpeed || _maxBackSpeed == 0)
						_backgroundSpeed += _backAccel;
						
					else if (_backgroundSpeed > -_maxBackSpeed)
					{
						_backgroundSpeed -= _runningBackDecelRate;
					}
				}
				if (_leftMove && !_rightMove)
				{
					if (_backgroundSpeed > -_maxBackSpeed || _backgroundSpeed == 0)
						_backgroundSpeed += _backAccel;
						
					else if (_speed < _maxSpeed)
					{
						_backgroundSpeed += _runningBackDecelRate;
					}
				}
			}
			
			else if (_backgroundSpeed > _maxBackSpeed && !_isBoosting)//speed control
				_backgroundSpeed = _maxBackSpeed;
				
			else if (_backgroundSpeed < -_maxBackSpeed && !_isBoosting)//speed control
				_backgroundSpeed = -_maxBackSpeed;
				
			if (_Xaccel == 0 && _speed != 0 && !_isBoosting)//Decelerate
			{
				if (Math.abs(_speed) < 1)
				{
					_speed = 0;
				}
				
				else
				{
					if (_canJump)
					{
						if (_speed > 0)
							_speed -= _decelRate;
						else	
							_speed += _decelRate;
					}
					else//adjusts jumping slowdown
					{
						if (_speed > 0)
							_speed -= 0.4;
						else	
							_speed += 0.4;
					}
				}
			}
			
			if (_backAccel == 0 && _backgroundSpeed != 0 && !_isBoosting)//Decelerate added is bossting bitch
			{
				if (Math.abs(_backgroundSpeed) < .5)
				{
					_backgroundSpeed = 0;
				}
				
				else
				{
					if (_backgroundSpeed > 0)
						_backgroundSpeed -= _backDecelRate;
					else	
						_backgroundSpeed += _backDecelRate;
				}
			}
			
			if (_speed < 0)//if player is moving right, change sprite AND COLLISION
			{
				if (!CheckCollision(_rightCollideBox))
				{
					if (_canAnimChange)
					{
						this.removeChild(_myClip);
						_myClip = _runRight;
						this.addChild(_myClip);
						_canAnimChange = false;
						_isIdle = false;
						if (_isBoosting)
						{
							stopBoost2();
						}
					}
				}
				else //if there is collision stop
				{
					_levelHolder.x = this.x + 60 - _XcollidingBlockDistance;
					_Xaccel = 0;
					_speed = 0;
					_backAccel = 0;
					_backgroundSpeed = 0;
					if (_isBoosting)
					{
						stopBoost2();
					}
				}
			}
			
			else if (_speed > 0) //If player is moving left, change sprite AND COLLISION
			{
				if (!CheckCollision(_leftCollideBox))
				{
					if (_canAnimChange)
					{
						this.removeChild(_myClip);
						_myClip = _runLeft;
						this.addChild(_myClip);
						_canAnimChange = false;
						_isIdle = false;
						if (_isBoosting)
						{
							stopBoost2();
						}
					}
				}
				else//if there is collision, stop
				{
					_levelHolder.x = this.x - _XcollidingBlockDistance - 32;
					_Xaccel = 0;
					_speed = 0;
					_backAccel = 0;
					_backgroundSpeed = 0;
					if (_isBoosting)
					{
						stopBoost2();
					}
				}
			}
			
			//////////
			//Stops WallCling
			//////////
			if (_isWallClinged)//if no collision in any direction, stop wall cling
			{
				if(!CheckCollision(_leftCollideBox) && !CheckCollision(_rightCollideBox))
					StopWallCling2();
			}
			
			//move background based on changes to background speed
			Background._instance._background1.x += _backgroundSpeed;
			Background._instance._background2.x += _backgroundSpeed;
			Background._instance._background3.x += _backgroundSpeed;
			
			_levelHolder.x += _speed;//Move level holder based on changes to speed
			
			_prevYVelocity = _YVelocity;
			_prevX = _levelHolder.x;
			_prevY = _levelHolder.y;
			_previousKeyState = _keyState;
			
			//currentX = LevelConstructor._instance.getCurrentX();
			//currentY = LevelConstructor._instance.getCurrentY();
			//regionResult = currentX + (currentY * 3);
			
		}
		
		public function pause():void
		{
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN, CheckKeysDown);
			//stage.removeEventListener(KeyboardEvent.KEY_UP, CheckKeysUp);
			_paused = true;
			_controlsLocked = true;
			_boostTimer.stop();
		}
		
		public function unpause():void
		{
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, CheckKeysDown);
			//stage.addEventListener(KeyboardEvent.KEY_UP, CheckKeysUp);
			_paused = false;
			_controlsLocked = false;
			_boostTimer.start();
			if (_isWallClinged)
			{
				StopWallCling2();
			}
		}
		
		public function boost():void
		{
			if (_canJump)
			{
				_isBoosting = true;
				_canBoost = false;
				_groundBoost = true;
				
				if (_facing == 0)
				{
					_speed = -_boostSpeed;
					_backgroundSpeed = -_boostBackSpeed;
					
					this.removeChild(_myClip);
					_myClip = _boostRight;
					this.addChild(_myClip);
					
					_boostTimer.reset(); //seems to work without it
					_boostTimer.addEventListener(TimerEvent.TIMER, stopBoost);
					_boostTimer.start();
				}
				else
				{
					_speed = _boostSpeed;
					_backgroundSpeed = _boostBackSpeed;
					
					this.removeChild(_myClip);
					_myClip = _boostLeft;
					this.addChild(_myClip);
					
					_boostTimer.reset(); //seems to work without it
					_boostTimer.addEventListener(TimerEvent.TIMER, stopBoost);
					_boostTimer.start();
				}
			}
			else if(!_isWallClinged && _canAirBoost)
			{
				_isBoosting = true;
				_canBoost = false;
				_airBoost = true;
				_canAirBoost = false;
				
				if (_facing == 0)
				{
					_speed = -_boostSpeed;
					_backgroundSpeed = -_boostBackSpeed;
					_YVelocity = 0;
					
					this.removeChild(_myClip);
					_myClip = _boostRight;
					this.addChild(_myClip);
					
					_boostTimer.reset(); //seems to work without it
					_boostTimer.addEventListener(TimerEvent.TIMER, stopBoost);
					_boostTimer.start();
				}
				else
				{
					_speed = _boostSpeed;
					_backgroundSpeed = _boostBackSpeed;
					_YVelocity = 0;
					
					this.removeChild(_myClip);
					_myClip = _boostLeft;
					this.addChild(_myClip);
					
					_boostTimer.reset(); //seems to work without it
					_boostTimer.addEventListener(TimerEvent.TIMER, stopBoost);
					_boostTimer.start();
				}
			}
		}
		
		public function stopBoost2():void
		{
			if (!_death)
			{
				_boostTimer.reset();
				if (_canJump)
				{
					_isBoosting = false;
					_canBoost = true;
					_groundBoost = false;
					_airBoost = false;
					
					if (_facing == 0)
					{
						this.removeChild(_myClip);
						_myClip = _runRight;
						this.addChild(_myClip);
					}
					else
					{
						this.removeChild(_myClip);
						_myClip = _runLeft;
						this.addChild(_myClip);
					}
					
				}
				else if(_airBoost)
				{
					_isBoosting = false;
					_canBoost = true;
					_groundBoost = false;
					_airBoost = false;
					if (!_isWallClinged)
					{
						_YVelocity = 0;
					
						if (_facing == 0)
						{
							this.removeChild(_myClip);
							_myClip = _jumpRight;
							this.addChild(_myClip);
						}
						else
						{
							this.removeChild(_myClip);
							_myClip = _jumpLeft;
							this.addChild(_myClip);
						}
					}
				}
			}
		}
		
		public function stopBoost(e:Event):void
		{
			stopBoost2();
		}
		
		public function skidStop():void
		{
			
		}
		
		public function moveFrame()//animation called every couple of milliseconds
		{
			if (!_paused && !_death)
			{
				if (_myClip.currentFrame >= _myClip.totalFrames)//if on last frame, go to first frame
				{
					//clearInterval(_frameInt);
					//_frameInt = 0;
					_myClip.gotoAndStop(1);
				}
				else
				{
					_myClip.gotoAndStop(_myClip.currentFrame + 1);//else, increment frame
				}
			}
		}
		
		public function CheckKeysDown(keyState:KeyboardEvent):void
		{
			if (keyState.keyCode == 65)
			{
				_leftMove = true;

				if (!_controlsLocked)
				{
					if (CheckCollision(_rightCollideBox) && _isWallClinged)
					{
						WallJump();
					}
				}
			}
			if (keyState.keyCode == 68)
			{
				_rightMove = true;
				
				if (!_controlsLocked)
				{
					if (CheckCollision(_leftCollideBox) && _isWallClinged)
					{
						WallJump();
					}
				}
			}
			if (keyState.keyCode == 83)
			{
				_downMove = true;
			}
			if (keyState.keyCode == 87 || keyState.keyCode == 32)
			{
				if (_canUpPress == true)
				{
					_upMove = true;
					_canUpPress = false;
				}
			}
			if (keyState.keyCode == 74)//J Boost code
			{
				if (!_controlsLocked)
				{
					if (_canJPress == true)
					{
							if (_rightMove)
							{
								boost();
							}
							else if (_leftMove)
							{
								boost();
							}
					}
					_canJPress = false;
				}
			}

			if (keyState.keyCode == 75)//K
			{
				_canKPress = false;
			}
		}
		
		public function CheckKeysUp(keyState:KeyboardEvent):void
		{
			if (keyState.keyCode == 65)
			{
				_leftMove = false;
				_Xaccel = 0;
				_backAccel = 0;
				
				if (!_controlsLocked)
				{
					//_Xaccel = 0;
					//_backAccel = 0;
					
					if (_isWallClinged)
					{
						_wallClingReleaseTimer.reset(); 
						_wallClingReleaseTimer.addEventListener(TimerEvent.TIMER, StopWallCling);
						_wallClingReleaseTimer.start();
					}
				}
			}
			if (keyState.keyCode == 68)
			{
				_rightMove = false;
				_Xaccel = 0;
				_backAccel = 0;
				
				if (!_controlsLocked)
				{
					//_Xaccel = 0;
					//_backAccel = 0;
					
					if (_isWallClinged)
					{
						_wallClingReleaseTimer.reset();
						_wallClingReleaseTimer.addEventListener(TimerEvent.TIMER, StopWallCling);
						_wallClingReleaseTimer.start();
					}
				}
			}
			if (keyState.keyCode == 83)
				_downMove = false;
			if (keyState.keyCode == 87 || keyState.keyCode == 32)
			{
				_canUpPress = true;
				_upMove = false;
			}
			if (keyState.keyCode == 74)//J
			{
				//action code
				_canJPress = true;
				
			}

			if (keyState.keyCode == 75)//K
			{
				_canKPress = true;
			}
		}
		
		public function UpdateWallJump(e:Event):void
		{
			
			if (_facing == 0)//wall jump right
			{
				_speed = -_maxSpeed;//change 1
				_Xaccel = -_accelRate;
				
				var _rightCollide2:Boolean;
				//_rightMove = true;
				
				_rightCollide2 = CheckCollision(_rightCollideBox);
				
				if (!_rightCollide2)
				{
					if (_canAnimChange)
					{
						this.removeChild(_myClip);
						_myClip = _runRight;
						this.addChild(_myClip);
						_canAnimChange = false;
						_isIdle = false;
						
					}
					_levelHolder.x -= _wallJumpMaxSpeed;
					
					//background
					Background._instance._background1.x -= _maxBackSpeed;
					Background._instance._background2.x -= _maxBackSpeed;
					Background._instance._background3.x -= _maxBackSpeed;
				}
				else
				{
					_levelHolder.x =  this.x - _XcollidingBlockDistance - 32;
					
					if (_canJump == false) //&& _YVelocity >= -10)
					{
						_canWallCling = true;
						WallCling();
					}
				}
			}
			
			if (_facing == 1)//wall jump left
			{
				_speed = _maxSpeed;//change 2
				_Xaccel = _accelRate;
				
				var _leftCollide2:Boolean;
				//_leftMove = true;
				
				_leftCollide2 = CheckCollision(_leftCollideBox);
				
				if (!_leftCollide2)
				{
					if (_canAnimChange)
					{
						this.removeChild(_myClip);
						_myClip = _runLeft;
						this.addChild(_myClip);
						
						_canAnimChange = false;
						_isIdle = false;
					}
					_levelHolder.x += _wallJumpMaxSpeed;
					
					Background._instance._background1.x += _maxBackSpeed;
					Background._instance._background2.x += _maxBackSpeed;
					Background._instance._background3.x += _maxBackSpeed;
				}
				else
				{
					_levelHolder.x = this.x - _XcollidingBlockDistance - 32;
					
					if (_canJump == false) //&& _YVelocity >= -10)
					{
						_canWallCling = true;
						WallCling();
					}
				}
			}
			
			_listenerCount++;
			if (_listenerCount >= 2)
			{
				this.removeEventListener(Event.ENTER_FRAME, UpdateWallJump);
				_isWallJumping = false;
			}
		}
		
		public function WallJump():void
		{	
			_postWallJump = true;
			//move me sideways
			_levelHolder.y -= _YVelocity;
			_YVelocity = _jumpSpeed;
			
			if (_facing == 0)
			{
				_speed = -_maxSpeed;
				this.removeChild(_myClip);
				_myClip = _jumpRight;
				this.addChild(_myClip);
			}
			else if (_facing == 1)
			{
				_speed = _maxSpeed;
				this.removeChild(_myClip);
				_myClip = _jumpLeft;
				this.addChild(_myClip);
			}
			_upMove = false;
			_canAnimChange = false;
			_canJump = false;
			_pressedJump = true;
			_isIdle = false;
			
			if (_jumpCount >= 1)
			{
				_canDoubleJump = false;
			}
			else
				_jumpCount++;
			
			_isWallJumping = true;
			if (CheckCollision(_rightCollideBox))
			{
				_listenerCount = 0;
				this.addEventListener(Event.ENTER_FRAME, UpdateWallJump);
			}
			else if (CheckCollision(_leftCollideBox))
			{
				_listenerCount = 0;
				this.addEventListener(Event.ENTER_FRAME, UpdateWallJump);
			}
			
			
			_canDoubleJump = false;
			_isWallClinged = false;
		}
		
		public function WallCling():void
		{
			if (CheckCollision(_rightCollideBox))
			{
				_facing = 1;
				
				this.removeChild(_myClip);
				_myClip = _wallSlideRight;
				this.addChild(_myClip);
			}
			else if (CheckCollision(_leftCollideBox))
			{
				_facing = 0;
				
				this.removeChild(_myClip);
				_myClip = _wallSlideLeft;
				this.addChild(_myClip);
			}
			

			_canDoubleJump = true;
			_jumpCount = 0;
			_YVelocity = 3;
			_canWallCling = false;
			_isWallClinged = true;
			_canAnimChange = false;
			_canAirBoost = true;
			
			//_wallClingTimer.reset(); //seems to work without it
			//_wallClingTimer.addEventListener(TimerEvent.TIMER, StopWallCling);
			//_wallClingTimer.start();
			
		}
		
		public function StopWallCling(event:TimerEvent):void
		{
			if (_facing == 0)
			{
				this.removeChild(_myClip);
				_myClip = _jumpRight;
				this.addChild(_myClip);
			}
			else
			{
				this.removeChild(_myClip);
				_myClip = _jumpLeft;
				this.addChild(_myClip);
			}
			
			_canDoubleJump = false;
			_isWallClinged = false;
		}
		
		public function StopWallCling2():void
		{
			
			if (_facing == 0)
			{
				this.removeChild(_myClip);
				_myClip = _jumpRight;
				this.addChild(_myClip);
			}
			else
			{
				this.removeChild(_myClip);
				_myClip = _jumpLeft;
				this.addChild(_myClip);
			}
			
			_canDoubleJump = false;
			_isWallClinged = false;
		}
		
		public function Death():void
		{
			trace("called");
			//play death clip
			_controlsLocked = true;
			_Xaccel = 0;
			_backAccel = 0;
			_speed = 0;
			_backgroundSpeed = 0;
			_YVelocity = 0;
			this.removeChild(_myClip);
			//_myClip = _deathRight;
			//_myClip.currentFrame = 0;
			this.addChild(_myDeathClip);
			_myDeathClip.gotoAndStop(1);
			_death = true;
			_isIdle = false;
			
			_deathInt = setInterval(playDeathClip, 100);
			//clearInterval(_frameInt);
		}
		
		public function playDeathClip()
		{
			var _isDeathComplete:Boolean = false;
			if (!_paused)
			{
				trace("here");
				if (_myDeathClip.currentFrame >= _myDeathClip.totalFrames)//if on last frame, go to first frame
				{
					//clearInterval(_frameInt);
					//_frameInt = 0;
					//_myClip.gotoAndStop(1);
					_isDeathComplete = true;
					clearInterval(_deathInt);
					//fade
					Main._instance.fadeDeathScreen("death");
				}
				else
				{
					_myDeathClip.gotoAndStop(_myDeathClip.currentFrame + 1);//else, increment frame
				}
			}
		}
		
		public function CheckCollision(boundingBox:Sprite):Boolean //uses upper box 
		{	
			//var container:DisplayObjectContainer;
			//
			//container = WholeLevel.Instance().getLevelRegion(0);//regionResult
			
			for (var i:int = 0; i < _levelHolder.numChildren; i++)
			{
				var block:Wall = (Wall)(_levelHolder.getChildAt(i));
				
				if (boundingBox.hitTestObject(block))
				{
					_collidingBlock = block;
					block.interact();
					
					if (boundingBox == _upperCollideBox)
					{
						_collidingBlockDistance = _collidingBlock.y;
						return true;
					}
					else if (boundingBox == _bottomCollideBox)
					{
						_collidingBlockDistance = _collidingBlock.y;
						return true;
					}
					else if (boundingBox == _rightCollideBox)
					{
						_XcollidingBlockDistance = _collidingBlock.x;
						return true;
					}
					else 
					{
						_XcollidingBlockDistance = _collidingBlock.x;
						return true;
					}
				}
			}
			return false;
		}
	}
}