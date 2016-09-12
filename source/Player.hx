package;
/**
 * ...
 * @author Fuller Taylor
 */
 
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Player extends FlxSprite
{
	var speed:Float = 200;
	var _rot: Float = 0;
	// helper variables to be able to tell which keys are pressed
	var _up:Bool = false;
	var _down:Bool = false;
	var _left:Bool = false;
	var _right:Bool = false;
	
<<<<<<< HEAD
    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
		makeGraphic(16,28, FlxColor.PURPLE);
		//loadGraphic("assets/images/duck.png", true, 100, 114);
		// setFacingFlip(direction, flipx, flipy)
=======
	function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		
		
		createRectangularBody(16, 28);
		body.allowRotation = false;
		makeGraphic(16, 28, FlxColor.PURPLE);
		
>>>>>>> parent of 86e6be4... Checking in
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		//animation.add("walk", [0,1,0,2], 5, true);
		drag.x = drag.y = 1600;
    }
	 
	override public function update(elapsed:Float):Void
	{
		
		move();
		super.update(elapsed);
	}
	
	// written by Fuller
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
			}
			else if (_right)
			{
				_rot = 0;
				facing = FlxObject.RIGHT;
			}
		 	velocity.set(speed,0);
			velocity.rotate(new FlxPoint(0,0), _rot);
		}
		/*
		if (velocity.x != 0 || velocity.y != 0){
			animation.play("walk");
		}
		else animation.stop();
		*/
	}
	
}