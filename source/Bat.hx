package;

/**
 * ...
 * @author Fuller Taylor
 */

 import flixel.FlxSprite;
 import flixel.addons.nape.FlxNapeSprite;
 import flixel.util.FlxColor;
 import flixel.FlxG;
 import flixel.math.FlxPoint;
 import flixel.FlxObject;

class Bat extends FlxNapeSprite
{
	var _paired:Bool = true;		// is the bat paired with the player? If it is, it will move with the player.
	var _player_speed:Float;
	
	var speed:Float = 300;
	var _rot: Float = 0;
	var _up:Bool = false;
	var _down:Bool = false;
	var _left:Bool = false;
	var _right:Bool = false;
	
	var _w:Bool = false;
	var _s:Bool = false;
	var _a:Bool = false;
	var _d:Bool = false;
	var _spacebar:Bool = false;
	
	var Layer:Layers;
	
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		Layer = new Layers();
		
		
		loadGraphic("assets/images/Bat_Sprite_Sheet.png", true, 76, 25);// , 16, 16);
		animation.add("fly", [0, 1, 2, 3, 4], 12, true);
		animation.play("fly", false, false, -1);
		centerOffsets();
		createRectangularBody();
		body.allowRotation = false;
		body.shapes.at(0).filter = Layer.bat_filter;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		
		
		
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		// Here, play the animation. Because the bat is never walking, it should always be playing its animation. No need to check if its motionless.
		move();
		
	}
	
	// written by Fuller
	
	public function isPaired():Bool
	{
		return _paired;
	}
	
	public function setPlayerSpeed(s:Float):Void
	{
		_player_speed = s;
	}
	
	
	// written by Fuller
	public function togglePaired():Void
	{
		var output:String = "Toggled from ";
		if (_paired)
			output += "paired ";
		else
			output += "not paired ";
		
		output += "to ";
		if (_paired){
			body.velocity.setxy(0, 0);	// when unpairing, stop the bat's movement
		}
		
		_paired = !_paired;		// toggle the variable. Ultimately, the player should only be able to pair with the bat again within a certain range
		
		if (_paired)
			output += "paired ";
		else
			output += "not paired ";
		
		//FlxG.log.add(output);
		
	}
	
	// written by Fuller
	function move():Void
	{
		// very similar to the player.hx source file made in class
		_up = FlxG.keys.anyPressed([UP]);	// jump key?
		_left = FlxG.keys.anyPressed([LEFT]);
		_right = FlxG.keys.anyPressed([RIGHT]);
		
		_w = FlxG.keys.anyPressed([W]);
		_s = FlxG.keys.anyPressed([S]);
		_a = FlxG.keys.anyPressed([A]);
		_d = FlxG.keys.anyPressed([D]);
		
		// cancel out opposing directions
		if (_left && _right)
		{
			_left = _right = false;
		}
		if ( _w && _s )
		{
			_w = _s = false;
		}
		if ( _a && _d )
		{
			_a = _d = false;
		}
		
		// bat has been unpaired. should be controlled by WASD
		if (!_paired)
		{	
			if (_w || _s || _a || _d){
				if (_a)
				{
					_rot = 180;
					facing = FlxObject.LEFT;
					if (_w) _rot += 45;
					else if (_s) _rot -= 45;
				}
				else if (_d)
				{
					_rot = 0;
					facing = FlxObject.RIGHT;
					if (_w) _rot -= 45;
					else if (_s) _rot += 45;
				}
				else if (_s) _rot = 90;
				else if (_w) _rot = 270;
			 
				body.velocity.setxy(speed * Math.cos( -1 * _rot * 3.14159 / 180), speed * Math.sin(_rot * 3.14159 / 180));
			}
			else{
				body.velocity.setxy(0, 0);	// for polish, give the bat a hover when it's not being moved
			}
			
		}
		else{ // bat is paired with the player, thus bat moves with the arrow keys
			/*
			if (_left || _right)
			{
				if (_left)
				{
					_rot = 180;
					facing = FlxObject.LEFT;
					body.velocity.x = -_player_speed;
				}
				else if (_right)
				{
					_rot = 0;
					facing = FlxObject.RIGHT;
					body.velocity.x = _player_speed;
				}
			}
			else
			{
				body.velocity.x = 0;
			}*/
		}
		
	}
	
}