package;

/**
 * ...
 * @author Fuller Taylor, Eric Roque
 */

import flixel.addons.nape.FlxNapeSprite; 
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import nape.geom.Vec2;
import flixel.FlxG;


class StepTrigger extends FlxNapeSprite 
{
	var _rest_position:FlxPoint;
	var _depressed_position:FlxPoint;
    
    var _moving_to_depressed_position:Bool = true;

	var _upside_down:Bool;
    var _depressed:Bool;
    
    var _speed:Int = 60;
    
    var _moving:Bool = false;
	
	var _raising:Bool = false;		// same as _moving_to_origin variable in Gate.hx
    
    private var _times:Array<Float>; // will be used to count the FPS
	
	var Layer:Layers;
	
	public function new(?X:Float=0, ?Y:Float=0, ?flipped:Bool=false, ?depressed:Bool = false, ?image_path:String = "")
	{
		if ( image_path == "" ) image_path = "assets/images/blue button 1.png";
		
		super(X, Y, image_path, false, true);
		
		// set physics
		createRectangularBody(nape.phys.BodyType.KINEMATIC);
		setBodyMaterial(.945, 9999999, 9999999, 9999999, 9999999);
		body.gravMass = 50000;
		body.allowRotation = false;
		Layer = new Layers();
		body.shapes.at(0).filter = Layer.gate_filter;
		
		_rest_position = new FlxPoint(X, Y);
		_upside_down = flipped;
		_depressed = depressed;
        _times = [];
        
		if (!_upside_down)
		{
			_depressed_position = new FlxPoint(X, Y + (height));		// 6 because that's the height of the graphic
		}
		else
		{
			_depressed_position = new FlxPoint(X, Y - (height));		// 6 because that's the height of the graphic
		}
		
		
		FlxG.log.add(_rest_position);
		
		FlxG.log.add(_depressed_position);
		
		
		/* old code
		if (image_path == "")
		{	
			loadGraphic("assets/images/blue button 1.png", false);
		}
        makeGraphic(32, 6);
		loadGraphic("assets/images/blue button 1", false);
		loadGraphic(image_path, false);// , 16, 16)
        createRectangularBody();
        
		allowCollisions = 2;
		*/
		
		
		
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
	
	public function inMotion():Bool
	{
		return _moving;
	}
	
	public function isDepressed():Bool
	{
		return _depressed;
	}
    
	
	public function lower():Void
	{
		if (!_upside_down)
		{
			body.velocity.setxy(0, _speed);
		}
		else
		{
			body.velocity.setxy(0, -_speed);
		}
		
		_moving = true;
		_depressed = true;
		_moving_to_depressed_position = true;
	}
	
	public function raise():Void
	{
		if (!_upside_down)
		{
			body.velocity.setxy(0, -_speed);
		}
		else
		{
			body.velocity.setxy(0, _speed);
		}
		_moving = true;
		_depressed = false;
		_moving_to_depressed_position = false;
	}
     
	
    function checkIfReached():Void
	{
		var reached:Bool = false;
		if (_moving_to_depressed_position)	// if moving to the origin, check the distance to the origin
		{
			reached = FlxMath.isDistanceToPointWithin(this, _depressed_position, _speed / _times.length, true);	// _times.length = FPS
			//body.velocity.setxy(0, 0);
		}
		else					// if moving away from the origin, check the distance to the target
		{
			reached = FlxMath.isDistanceToPointWithin(this, _rest_position, _speed / _times.length, true);
            //body.velocity.setxy(0, 0);
		}
		
		if (reached)
		{
			//FlxG.log.add("ARRIVED. _depressed: " + _depressed);
			body.velocity.setxy(0, 0);
			_moving = false;
			if (_moving_to_depressed_position)
			{
				body.position.set(new Vec2(_depressed_position.x, _depressed_position.y));
			}
			else
			{
				body.position.set(new Vec2(_rest_position.x, _rest_position.y));
			}
			_moving_to_depressed_position = !_moving_to_depressed_position;
			
		}
		
	}
	
	
	
}