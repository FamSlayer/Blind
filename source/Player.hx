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
	// helper variables to be able to tell which keys are pressed
	var _up:Bool = false;
	var _down:Bool = false;
	var _left:Bool = false;
	var _right:Bool = false;
	
<<<<<<< HEAD
=======
<<<<<<< HEAD
    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
		makeGraphic(16,28, FlxColor.PURPLE);
		//loadGraphic("assets/images/duck.png", true, 100, 114);
		// setFacingFlip(direction, flipx, flipy)
=======
>>>>>>> 132f4b77d9f61395a517d59c37e4452786dece9c
	function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		
		
		createRectangularBody(16, 28);
		body.allowRotation = false;
		makeGraphic(16, 28, FlxColor.PURPLE);
		
<<<<<<< HEAD
=======
>>>>>>> parent of 86e6be4... Checking in
>>>>>>> 132f4b77d9f61395a517d59c37e4452786dece9c
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		//setBodyMaterial(1, 0.2, 0.4, 250); 		// set stupid high density to be less afected by blob weight.
		//body.gravMass = 10; 						// cancels gravity for this object.
		
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		
		move();
		super.update(elapsed);
		
	}
	
	public function getSpeed():Float
	{
		return speed;
	}
	
	
	function move():Void
	{
		_up = FlxG.keys.anyPressed([UP]);
		_left = FlxG.keys.anyPressed([LEFT]);
		_right = FlxG.keys.anyPressed([RIGHT]);
		
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