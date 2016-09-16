package;
/**
 * ...
 * @author Fuller Taylor
 */

import flixel.addons.nape.FlxNapeSprite;
//import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import nape.geom.Vec2;

import flixel.FlxG; // for printing to the debugger


class Gate extends FlxNapeSprite
{
	var _move_to:FlxPoint;
	var _origin:FlxPoint;
		
	var _moving_to_origin:Bool = false;
	var _start_down:Bool;
	var _start_right:Bool;
	var _vertical:Bool;
	
	var _speed:Int = 100;
	
	var _moving:Bool = false;
	
	private var _times:Array<Float>; // will be used to count the FPS
	
	function new(?X:Float = 0, ?Y:Float = 0, ?dX:Float = 0, ?dY:Float = 0 )
	{
		super(X, Y);
		_moving_to_origin = false;
		_origin = new FlxPoint(X, Y);
		_move_to = new FlxPoint(dX, dY);
		_times = [];
		
		makeGraphic(15,60);
        createRectangularBody();
        setBodyMaterial(.6, 9999999, 9999999, 9999999, 9999999);	//non-elastic, the rest of the numbers basically say "should not be moved by other stuff"
		body.allowRotation = false;
		
		// bunch of logic to determine how the gate will move based on the origin and destination given in the constructor
		if (Y != dY)
		{
			_vertical = true;
			if (Y > dY)
			{
				_start_down = false;
			}
			else
			{
				_start_down = true;
			}
		}
		else{
			_vertical = false;
			if ( X > dX )
			{
				_start_right = true;
			}
			else
			{
				_start_right = false;
			}
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		var t = flixel.FlxG.game.ticks;
		
		if (_moving)
		{
			checkIfReached();
		}
			
		var now:Float = t / 1000;
		_times.push(now);	// every frame pushes a value into _times
		
		while (_times[0] < now - 1)	// if a second has elapsed since times[0] was pushed into the array, remove times[0] and shift the array over
		{
			_times.shift();
		}
		
		// OUR FPS IS _times.length
		
	}
	
	public function trigger():Void
	{
		if (_moving_to_origin)
		{
			FlxG.log.add("[Gate.hx] _moving_to_origin = true");
		}
		else
		{
			FlxG.log.add("[Gate.hx] _moving_to_origin = false");
		}
		
		if (_vertical)	// platform will move vertically
		{
			if (_start_down)
			{
				if (!_moving_to_origin){
					body.velocity.setxy(0, _speed);
				}
				else{	// moving back to its original state
					body.velocity.setxy(0, -_speed);
				}
			}
			else
			{
				if (!_moving_to_origin){
					body.velocity.setxy(0, -_speed);
				}
				else{	// moving back to its original state
					body.velocity.setxy(0, _speed);
				}
			}
		}
		else 			// platform will move horizontally
		{
			if (_start_right) // does the platform start right or left first
			{
				if (!_moving_to_origin)
				{
					body.velocity.setxy(-_speed, 0);
				}
				else
				{
					body.velocity.setxy(_speed, 0);
				}
			}
			else
			{
				if (!_moving_to_origin)
				{
					body.velocity.setxy(_speed, 0);
				}
				else
				{
					body.velocity.setxy(-_speed, 0);
				}
				
			}
		}
		_moving = true;
		FlxG.log.add("[Gate.hx] Set _moving to: ");
		FlxG.log.add(_moving);
	}
	
	
	function checkIfReached():Void
	{
		var reached:Bool = false;
		if (_moving_to_origin)	// if moving to the origin, check the distance to the origin
		{
			reached = FlxMath.isDistanceToPointWithin(this, _origin, _speed / _times.length, true);
			// _times.length = FPS
		}
		else					// if moving away from the origin, check the distance to the target
		{
			reached = FlxMath.isDistanceToPointWithin(this, _move_to, _speed / _times.length, true);
		}
		
		if (reached)
		{
			if (_moving_to_origin)
			{
				body.position.set(new Vec2(_origin.x, _origin.y));
			}
			else
			{
				body.position.set(new Vec2(_move_to.x, _move_to.y));
			}
			body.velocity.setxy(0, 0);
			_moving = false;
			_moving_to_origin = !_moving_to_origin;
		}
		
	}
	
	public function inMotion():Bool
	{
		return _moving;
	}
	
	
}