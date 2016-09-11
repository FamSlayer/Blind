package;
/**
 * ...
 * @author Fuller Taylor
 */
import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
//import flixel.addons.nape.FlxNapeSpace;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Player extends FlxNapeSprite
{
	var speed:Float = 100;
	var _rot: Float = 0;
	// helper variables to be able to tell which keys are pressed
	var _up:Bool = false;
	var _down:Bool = false;
	var _left:Bool = false;
	var _right:Bool = false;
	
    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
		//makeGraphic(16,28, FlxColor.PURPLE);
		//loadGraphic("assets/images/leg.png", true);// , 16, 28);			// leg.png makes the sprite the haxeflixel logo! which is fine with me honestly
		// setFacingFlip(direction, flipx, flipy)
		//setFacingFlip(FlxObject.LEFT, true, false);
		//setFacingFlip(FlxObject.RIGHT, false, false);
		
		//animation.add("walk", [0,1,0,2], 5, true);
		//drag.x = drag.y = 1600;
		
		//body.position.x = X;
		//body.position.y = Y;
    }
	 
	override public function update(elapsed:Float):Void
	{
		//move();
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
		 	//body.velocity.setxy(speed * Math.cos(_rot * 3.14/ 180), 0);
			//body.angularVel = 30;	
			//velocity.rotate(new FlxPoint(0,0), _rot);
		}
		/*
		if (velocity.x != 0 || velocity.y != 0){
			animation.play("walk");
		}
		else animation.stop();
		*/
	}
	
}