package;
/**
 * ...
 * @author Gabriel Langlois
 */

import flixel.FlxSprite;
import flixel.addons.nape.FlxNapeSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;

class Block extends FlxNapeSprite
{
	
    public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		makeGraphic(16, 16, FlxColor.RED);
		
		createRectangularBody(16, 16);
		body.allowRotation = false;
		body.allowMovement = false;
		physicsEnabled = false;
		immovable = true;
		moves = false;
		solid = true;
		mass = 100000000;
		
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}