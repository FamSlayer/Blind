package;
/**
 * ...
 * @author Fuller Taylor
 */
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Player extends FlxNapeSprite
{
	var speed:Float = 200;
	var _rot: Float = 0;
	var _can_jump:Bool = true;
	// helper variables to be able to tell which keys are pressed
	public var _up:Bool = false;
	var _down:Bool = false;
	var _left:Bool = false;
	var _right:Bool = false;
	
	var _the_bat:Bat;
	
	var Layer:Layers;
	
	function new(?X:Float=0, ?Y:Float=0, b:Bat, ?face_left:Bool = false)
	{
		super(X, Y, false, true);
		
		_the_bat = b;
        
        loadGraphic("assets/images/Idle_0.png", false);
		createRectangularBody(30, 106);
        body.allowRotation = false;
		body.gravMass = 55;
		
        //makeGraphic(16, 28, FlxColor.PURPLE);
		
		// set collision layer
		Layer = new Layers();
		body.shapes.at(0).filter = Layer.player_filter;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		//setBodyMaterial(1, 0.2, 0.4, 250); 		// set stupid high density to be less afected by blob weight.
		if (face_left){
			facing = FlxObject.LEFT;
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		move();
	}
	
	public function getSpeed():Float
	{
		return speed;
	}
	
	public function canJump():Bool
	{
		return _can_jump;
	}
	
	public function allowJump():Void
	{
		_can_jump = true;
	}
	
	function move():Void
	{
		_up = FlxG.keys.anyPressed([UP]);
		_left = FlxG.keys.anyPressed([LEFT]);
		_right = FlxG.keys.anyPressed([RIGHT]);
		
		if(_up && _can_jump)
		{
			body.velocity.y = -525;
			_the_bat.body.velocity.y = -525;
			_can_jump = false;
		}
		
		// cancel out opposing directions
		if (_left && _right)
		{
			_left = _right = false;
		}
		
		// actual movement itself
		if (_left || _right)
		{
			if (_left)
			{
				_rot = 180;
				facing = FlxObject.LEFT;
				body.velocity.x = -speed;
			}
			else if (_right)
			{
				_rot = 0;
				facing = FlxObject.RIGHT;
				body.velocity.x = speed;
			}
		}
		else
		{
			body.velocity.x = 0;
		}
	}
}