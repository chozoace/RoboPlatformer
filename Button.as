package 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Roger
	 */
	public class Button extends MovieClip
	{
		var _myClip:MovieClip;
		var _selected:Boolean = false;
		
		public function StopAt(stopIndex:int)
		{
			_myClip.gotoAndStop(stopIndex);
		}
		
		public function Update()
		{
			if (!_selected)
			{
				if(this._myClip.currentFrame != 1)
					StopAt(1);
			}
			else
			{
				if(this._myClip.currentFrame != 2)
					StopAt(2);
			}
		}
	}
	
}