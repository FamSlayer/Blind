package;

/**
 * ...
 * @author Fuller Taylor, Eric Roque
 */

import flixel.addons.nape.FlxNapeSprite; 
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import nape.geom.Vec2;


class StepTrigger extends FlxNapeSprite 
{
	var _rest_position:FlxPoint;
	var _depressed_position:FlxPoint;
    
    var _moving_to_depressed_position:Bool = false;
	var _upside_down:Bool;
    var _depressed:Bool;
    
    var _speed:Int = 100;
    
    var _moving:Bool = false;
    
    private var _times:Array<Float>; // will be used to count the FPS
	
	public function new(?X:Float=0, ?Y:Float=0, ?flipped:Bool=false, ?depressed:Bool = false)
	{
		super(X, Y);
		
		_rest_position = new FlxPoint(X, Y);
		_upside_down = flipped;
		_depressed = depressed;
        _times = [];
        
        makeGraphic(32,4);
        createRectangularBody();
        setBodyMaterial(9999999,9999999,9999999,9999999,9999999);
		
		if (!flipped)
		{
			_depressed_position = new FlxPoint(X, Y + 1);
		}
		else
		{
			_depressed_position = new FlxPoint(X, Y - 1);
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
        if (!_upside_down)
        {
            if (!_moving_to_depressed_position)
            {
                body.velocity.setxy(0, -_speed);
            }
            else
            {	
                // moving back to its original state
				body.velocity.setxy(0, _speed);
            }
        }
        else
        {
            if (!_moving_to_depressed_position)
            {
				body.velocity.setxy(0, _speed);
            }
            else
            {	
                // moving back to its original state
				body.velocity.setxy(0, -_speed);
            }
        }
        _moving = true;
    }
    
    function checkIfReached():Void
	{
		var reached:Bool = false;
		if (_moving_to_depressed_position)	// if moving to the origin, check the distance to the origin
		{
			reached = FlxMath.isDistanceToPointWithin(this, _depressed_position, _speed / _times.length, true);
			// _times.length = FPS
		}
		else					// if moving away from the origin, check the distance to the target
		{
			reached = FlxMath.isDistanceToPointWithin(this, _rest_position, _speed / _times.length, true);
		}
		
		if (reached)
		{
			if (_moving_to_depressed_position)
			{
				body.position.set(new Vec2(_depressed_position.x, _depressed_position.y));
			}
			else
			{
				body.position.set(new Vec2(_rest_position.x, _rest_position.y));
			}
			body.velocity.setxy(0, 0);
			_moving = false;
			_moving_to_depressed_position = !_moving_to_depressed_position;
		}
		
	}
	
	public function inMotion():Bool
	{
		return _moving;
	}
	
}