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
	var destinationTimer:Float = 0;
	var radius:Float;
	//var destinationJoint:DistanceJoint;
	
	var speed:Float = 100;
	var _rot: Float = 0;
	// helper variables to be able to tell which keys are pressed
	var _up:Bool = false;
	var _down:Bool = false;
	var _left:Bool = false;
	var _right:Bool = false;
	
	function new(?X:Float=0, ?Y:Float=0)
	{
		var rand = FlxG.random.int(0, 4);
		/*
		var graphic:String = "assets/blob/Twinkle";
		
		switch (rand)
		{
			case 0: graphic += "10Y.png"; radius = 10;
			case 1: graphic += "3Y.png"; radius = 3;
			case 2: graphic += "4B.png"; radius = 4;
			case 3: graphic += "5B.png"; radius = 5;
			case 4: graphic += "5Y.png"; radius = 5;
		}
		*/
		super(X, Y);
		body.allowRotation = false;
		
		createRectangularBody(16,28);
		
		//setBodyMaterial(1, 0.2, 0.4, 250); 		// set stupid high density to be less afected by blob weight.
		body.gravMass = 10; 						// cancels gravity for this object.
		
		//destinationJoint = new DistanceJoint(FlxNapeSpace.space.world, body, new Vec2(body.position.x, body.position.y),
		//						body.localCOM, 0, 0);
		
		//constrain.active = false; <- default is true
		//destinationJoint.stiff = false;  
		//destinationJoint.damping = 0;
		//destinationJoint.frequency = .22 + radius * 2 / 100;
		
		//destinationJoint.anchor1 = new Vec2(body.position.x, body.position.y);
		//destinationJoint.space = FlxNapeSpace.space;		 
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		move();
		/*
		if (destinationTimer <= 0)
		{
			destinationTimer = FlxG.random.float(0.6, 4.6);
			
			var newX = body.position.x + FlxG.random.float( -100, 100);
			var newY = body.position.y + FlxG.random.float( -100, 100);
			
			if (newX > 640 - 50) newX = 640 - 50;
			if (newX < 50) newX = 50;
			
			if (newY > 480 - 100) newY = 480 - 100;
			if (newY < 100) newY = 100;
			
			//destinationJoint.anchor1 = new Vec2(newX, newY);
		}
		
		destinationTimer -= elapsed;
		*/
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
			
		 	//body.velocity.setxy(speed * Math.cos(_rot * 3.14/ 180), 0);
			//body.angularVel = 30;	
			//velocity.rotate(new FlxPoint(0,0), _rot);
		}
		else
		{
				body.velocity.x = 0;
		}
		/*
		if (velocity.x != 0 || velocity.y != 0){
			animation.play("walk");
		}
		else animation.stop();
		*/
	}
}