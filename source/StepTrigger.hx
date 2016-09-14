package;

/**
 * ...
 * @author Fuller Taylor, Eric Roque
 */

import flixel.addons.nape.FlxNapeSprite; 
import flixel.math.FlxPoint;
//import flixel.FlxMath;

class StepTrigger extends FlxNapeSprite 
{
	var _rest_position:FlxPoint;
	var _depressed_position:FlxPoint;
	var _upside_down:Bool;
	
	public function new(?X:Float=0, ?Y:Float=0, ?flipped:Bool=false, ?depressed:Bool = false)
	{
		super(X, Y);
		
		_rest_position = new FlxPoint(X, Y);
		_upside_down = flipped;
		_depressed_position = depressed;
		
		if (!flipped)
		{
			_depressed_position = new FlxPoint(X, Y + 6);
		}
		else
		{
			_depressed_position = new FlxPoint(X, Y - 6);
		}
		
	}
	
}