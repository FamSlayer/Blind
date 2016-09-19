package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeSpace;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import nape.util.Debug;

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
	
    var _stepTrigger:StepTrigger;
    var _light:FlxNapeSprite;
	
    var _batplatform:FlxNapeSprite;
    var _gate:Gate;
	
	var _temp_ground:FlxNapeSprite;
	
	var Layer:Layers;
    

	var _debug_line:FlxSprite;
    var background:FlxSprite;
    
	
	override public function create():Void
	{
		
		super.create();
		FlxNapeSpace.init();
		Layer = new Layers();
		
		
		
		
        loadBackground();
		
		_temp_ground = new FlxNapeSprite(500, 400);
        _temp_ground.makeGraphic(800, 20, FlxColor.BROWN);
        _temp_ground.createRectangularBody();
		_temp_ground.body.allowMovement = false;
		_temp_ground.body.allowRotation = false;
		_temp_ground.setBodyMaterial(.945, 9999999, 9999999, 9999999, 9999999);
		_temp_ground.body.gravMass = 300000;
		
		Layer = new Layers();
		_temp_ground.body.shapes.at(0).filter = Layer.ground_filter; // SETS THE GROUND TO THE CORRECT COLLISION LAYER
		
        add(_temp_ground);
		
		_standable_objects = new FlxGroup();
		_standable_objects.add(_temp_ground);
        
		
        addPlatformAndLight();
		addPlayerAndBat();
        addBatPlatformAndRock();
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		checkPairPressed();		// check if the player is trying to pair themself with the bat again
		if (_bat.isPaired()) movePairTogether();	// if bat is still paired, set _bat.body.velocity = player.body.velocity
		applyGravity();
		
		reset();
		
		
        platformTouched();
        batPlatformTouched();
		
		/*
		var x:Float = _player.x + _player.width / 2;
		var y:Float = _player.y + _player.height;
		_debug_line = new FlxSprite(x,y);
		_debug_line.makeGraphic(1, 1);
		add(_debug_line);
		*/
		
	}
    
    public function reset():Void
    {
        if (FlxG.keys.anyPressed([R]))
        {
            FlxG.resetState();
        }
    }
    
    public function loadBackground():Void
    {
        background = new FlxSprite();
        background.loadGraphic("assets/images/Cave_fore_background.png");
        add(background);
    }
    
    public function loadMidground():Void
    {
        
    }
    
    public function loadForeground():Void
    {
        
    }
	
	// Written by Fuller
	function movePairTogether():Void
	{
		_bat.body.velocity = _player.body.velocity;
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
					//FlxG.log.add("Applying gravity to the bat");
					_bat.body.velocity.y += 10;
				}
				else{
					//FlxG.log.add("NOT APPLYING");
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
        
        _gate = new Gate(800,400, 800,300, 15, 60);
        
        add(_batplatform);
        add(_gate);
		
		_standable_objects.add(_gate);
    }
    
    //written by Eric, modified by Fuller
    function addPlatformAndLight():Void
    {
		
		_light = new FlxNapeSprite(450, 250);
		_light.makeGraphic(32, 400, FlxColor.YELLOW);
        _light.createRectangularBody();
        _light.setBodyMaterial(9999999, 9999999, 9999999, 9999999, 9999999);
		_light.body.shapes.at(0).filter = Layer.light_filter;
		
		
        _stepTrigger = new StepTrigger(400, 390 - 6);	// i had to hardcode and guess this location through trial and error. I'm not sure there is a better way
		// it is 390 - 6 because "6" is the height of the step trigger. When we import the sprite for it, this number will have to change to match the sprite
		_standable_objects.add(_stepTrigger);
		
        add(_light);
        add(_stepTrigger);
		
    }
    
    //written by Eric, modified by Fuller
    function platformTouched():Void
    {
		var y:Float = _player.y + _player.height; 		// y position of the player's feet!
		var x:Float = _player.x + _player.width / 2; 	// x position of the player's feet
        
		//FlxG.log.add("Y: " + y + "\tPlatform.y: " + _stepTrigger.y);
		
		if (  Math.abs(y - _stepTrigger.y) < .5 && _stepTrigger.x <= x  && x <= _stepTrigger.x + _stepTrigger.width )
		{
			
			//FlxG.log.add("collision");
			
            _light.kill();
		}
		else
		{
			if (_light.body.space == null)		// what ".kill()" does is call the parent's kill() and delete the rigidbody
				// I HOPE that the only time the body.space will be nulled out is after a kill call, and I THINK that'll be true!
				// otherwise, create a boolean variable that just keeps track of whether the object is deleted or not!
			{
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
	
	

}
