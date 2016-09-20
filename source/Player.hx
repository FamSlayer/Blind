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
	
	var drop_timer:Int = 30;
	
	function new(?X:Float=0, ?Y:Float=0, b:Bat, ?face_left:Bool = false)
	{
		super(X, Y, false, true);
		
		_the_bat = b;
        
		// load animation sprite sheet
		loadGraphic("assets/images/jump_sprite_sheet12.png", true, 53, 125);// , 16, 16);
		animation.add("jump", [1, 2, 3, 3, 3, 3, 3, 2, 1, 0], 10, false);	
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
	}
	

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		move();
		checkDrops();
		//checkFootsteps();
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
	
	//Written by Gabriel
	/*
	public function checkFootstep():Void {
		if (animation.name == "walk") {
			if (animation.frameIndex == 1 || animation.frameIndex == 4) {
				FlxG.sound.play("footstep");
			}
		}
	}
	*/
	
	//written by Gabriel
	public function checkDrops():Void {
		drop_timer -= 1;
		if (drop_timer <= 0) {
			FlxG.sound.play("water_droplet");
			drop_timer = FlxG.random.int(300, 900);
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
		// if 
	}
}