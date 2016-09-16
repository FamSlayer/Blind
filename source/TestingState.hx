package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeSpace;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

import nape.dynamics.InteractionFilter;

import flixel.FlxG; // for debug logging


using flixel.util.FlxSpriteUtil;


class TestingState extends FlxState
{
	var _playerY:Int = 200;
	var _playerX:Int = 20;
	var _player:Player;
	
	var _bat:Bat;
	var _test:FlxNapeSprite;
	
	var _standable_objects:FlxGroup;
	
    var _platform:StepTrigger;
    var _light:FlxNapeSprite;
	
    var _batplatform:FlxNapeSprite;
    var _gate:Gate;
	
	var _temp_ground:FlxNapeSprite;
    
	
	override public function create():Void
	{
		
		super.create();
		FlxNapeSpace.init();
		
		_temp_ground = new FlxNapeSprite(500, 400);
        _temp_ground.makeGraphic(800, 20, FlxColor.BROWN);
        _temp_ground.createRectangularBody();
		_temp_ground.body.allowMovement = false;
		_temp_ground.body.allowRotation = false;
		_temp_ground.setBodyMaterial(.945, 9999999, 9999999, 9999999, 9999999);
        //_temp_ground.body.velocity.x = 5;
        add(_temp_ground);
		
		_standable_objects = new FlxGroup();
		_standable_objects.add(_temp_ground);
        
		
		addPlayerAndBat();
        addPlatformAndLight();
        addBatPlatformAndRock();
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		checkPairPressed();		// check if the player is trying to pair themself with the bat again
		if (_bat.isPaired()) movePairTogether();	// if bat is still paired, set _bat.body.velocity = player.body.velocity
		applyGravity();
		
		
		
		
        platformTouched();
        batPlatformTouched();
	}
	
	// written by Gabriel, modified by Fuller
	public function applyGravity():Void {
		if (FlxG.collide(_player, _standable_objects) && !_player._up)
		{
			//FlxG.log.add("_player is colliding with a _standable_object");
			_player.body.velocity.y = 0;
			
			if (_bat.isPaired())	// move the bat with the player if they are paired
			{
				_bat.body.velocity.y = 0;
			}
			
			// and set the y position of the player to be perfectly standing on the object? This should reduce the elastic bouncing effect?
			if (! _player.canJump())
			{
				_player.allowJump();
			}
		}
		else
		{
			//FlxG.log.add("not colliding, applying gravity to player");
			_player.body.velocity.y += 10;
			
			if (_bat.isPaired())	// move the bat with the player if they are paired
			{
				if ( (_bat.y - _bat.height / 2.0)  < (_player.y - _player.height * .8) ) // bat will stop falling below the player..?
				{
					FlxG.log.add("Applying gravity to the bat");
					_bat.body.velocity.y += 10;
				}
				else{
					FlxG.log.add("NOT APPLYING");
				}
			}
		}
	}
    
    //written by Eric, modified by Fuller
    function addBatPlatformAndRock():Void
    {
        _batplatform = new FlxNapeSprite(800,100);
        _batplatform.makeGraphic(8,8);
        _batplatform.createRectangularBody();
        _batplatform.setBodyMaterial(9999999,9999999,9999999,9999999,9999999);
        
        _gate = new Gate(800,400, 800,300);
        
        add(_batplatform);
        add(_gate);
    }
    
    //written by Eric, modified by Fuller
    function addPlatformAndLight():Void
    {
		
		_light = new FlxNapeSprite(400, 100);
		_light.makeGraphic(32, 4);
        _light.createRectangularBody();
        _light.setBodyMaterial(9999999, 9999999, 9999999, 9999999, 9999999);
		
		
        _platform = new StepTrigger(400, 390 - 6);	// i had to hardcode and guess this location through trial and error. I'm not sure there is a better way
		// it is 390 - 6 because "6" is the height of the step trigger. When we import the sprite for it, this number will have to change to match the sprite
        
        add(_light);
        add(_platform);
    }
    
    //written by Eric, modified by Fuller
    function platformTouched():Void
    {
        //if (FlxG.keys.anyPressed([P]) && FlxG.collide(_player, _platform))
		if(FlxG.collide(_player, _platform))
        {
            _light.kill();
            _platform.trigger();
        }
		else
		{
            
			if (_light.body.space == null)		// what ".kill()" does is call the parent's kill() and delete the rigidbody
				// I HOPE that the only time the body.space will be nulled out is after a kill call, and I THINK that'll be true!
				// otherwise, create a boolean variable that just keeps track of whether the object is deleted or not!
			{
                _platform.trigger();
				_light.revive();
			}
            
		}
    }
    
    //written by Eric, modified by Fuller
    function batPlatformTouched():Void
    {
        //if (FlxG.keys.anyPressed([B]) && FlxG.collide(_bat, _batplatform))
		if (FlxG.collide(_bat, _batplatform))
        {
			//FlxG.log.add("Bat is pushing the button");
			if ( !_gate.inMotion())
			{
				
				//FlxG.log.add("_gate.trigger() called");
				_gate.trigger();
				//FlxG.log.add("");
			}
            //_batplatform.kill();
        }

    }
	
	
	// written by Fuller
	function addPlayerAndBat():Void 	
	{
		_bat = new Bat(_playerY-24, _playerY-8);
		_player = new Player(_playerY, _playerY, _bat);
		
		_bat.body.velocity = _player.body.velocity;
		
		add(_player);
		add(_bat);
	}
	
	// written by Fuller
	function checkPairPressed():Bool	
	{
		if ( FlxG.keys.justPressed.SPACE)	// by pushing space, the player tries to pair themself back to the bat again
		{
			// is the bat already paired? If so, then unpair it!
			if (_bat.isPaired()) // unpair
			{	
				_bat.togglePaired();
				return true;
			}
			else{
				// should only pair if the bat is within a certain range
				var maxPairingDistance:Float = 70.0;
				
				// Is it close enough to pair with the player?
				if ( FlxMath.isDistanceWithin(_bat, _player, maxPairingDistance, true) ) 	// yes
				{
					if ( (_bat.y - _bat.height / 2.0)  < (_player.y - _player.height * .8) ) // bat is above the player's torso. The bat _should_ never be below the ground anyway though
					{
						_bat.togglePaired();	
						return true;
					}
				}
				// no, it's not close enough. Hits the return statement at the end of the function and returns false
			}
			
		}
		return false;
	}
	
	function movePairTogether():Void
	{
		_bat.body.velocity = _player.body.velocity;
	}

}
