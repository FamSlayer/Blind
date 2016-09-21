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

import flixel.system.FlxSound;

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
	
	var drop_timer:Int = 30;
	var wind_timer:Int = 20;
	
	
	var wind_sound:FlxSound;
	var water_droplet:FlxSound;
	
	
	function new(?X:Float=0, ?Y:Float=0, b:Bat, ?face_left:Bool = false)
	{
		super(X, Y, false, true);
		
		_the_bat = b;
        
		// load animation sprite sheet
		loadGraphic("assets/images/WalkIdleSpriteSheet.png", true, 72, 120);// , 16, 16);
		animation.add("walk", [0, 1, 2, 3, 4, 5], 12, true);
		animation.add("idle", [6, 7, 8], 4, true);
		animation.add("jump", [9, 10], 8, false);
		animation.add("falling", [11, 12, 13], 12, true);
		
		//animation.add("jump", [1, 2, 3, 3, 3, 3, 3, 2, 1, 0], 10, false);	
		// I'm literally just playing with the order of the frames so Amanda doesn't have to change any frames. - Fuller 
		
		//animation.add("idle", [0, 0], 2, false);
		//animation.play("jump");
		centerOffsets();
        //loadGraphic("assets/images/Idle_0.png", false);
		createRectangularBody();// 53, 106);
        body.allowRotation = false;
		body.gravMass = 55;
		
		
		
		// set collision layer
		Layer = new Layers();
		body.shapes.at(0).filter = Layer.player_filter;
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		//setBodyMaterial(1, 0.2, 0.4, 250); 		// set stupid high density to be less afected by blob weight.
		if (face_left){
			facing = FlxObject.LEFT;
		}
		
		
		
		//wind_sound = FlxG.sound.load("assets/sounds/wind.wav");
		water_droplet = FlxG.sound.load("assets/sounds/water_droplet.wav");
		//FlxG.sound.playMusic("assets/music/theme1.ogg");
	}
	

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		move();
		checkDrops();
		//checkFootstep();
		checkWind();
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
	
	
	//written by Gabriel
	public function checkDrops():Void {
		drop_timer -= 1;
		if (drop_timer <= 0) {
			//FlxG.sound.play("assets/sounds/water_droplet.wav");
			water_droplet.play();
			drop_timer = FlxG.random.int(300, 900);
		}
	}
	
	//written by Gabriel
	public function checkWind():Void {
		wind_timer -= 1;
		if (wind_timer <= 0) {
			//wind_sound.play();
			wind_timer = 38 * 30;
		}
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
			animation.play("jump");
			// play the player's jump animation, and leave it in the final pose
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
		
		// if x velocity = 0 and y velocity = 0,  play idle animation on repeat
		// if x velocity = 0 and y velocity = 0,  play walking animation
		// if y velocity is <= 0 (jumping)
		// if y velocity is >= 0 (falling)
		
		if (body.velocity.y <= -50)
		{
			if ( animation.name != "jump"){
				animation.play("jump");
			}
		}
		else if (body.velocity.y >= 50)
		{
			animation.play("falling");
		}
		else	// not jumping or falling, 
		{
			if (_can_jump){ // the player is on a standable object
				//if (body.velocity.x != 0) 	// if the player is walking
				var threshold:Int = 10;
				if ( body.velocity.x <= -threshold || body.velocity.x >= threshold )
				{
					animation.play("walk");
				}
				else 						// player is idle, in both x and y
				{
					animation.play("idle");
				}
			}
			
		}
		
		
	}
}