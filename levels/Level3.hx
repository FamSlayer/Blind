package levels;

/*
 * @authors
 * Template written by: Fuller
 * Started by: Eric
 * Finalized by: Fuller
 */


import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeSpace;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.FlxObject;
import Layers;

class Level3 extends FlxState
{
	var _playerY:Int = 560;
	var _playerX:Int = 875;
	var _ground_height:Int = 680;
    var _player:Player;
	var _bat:Bat;
    var _light:FlxNapeSprite;
	var _stepTrigger:StepTrigger;
    var _batplatform:FlxNapeSprite;
    var _gate:Gate;
    var _gate1:Gate;
    var _nextLevelBlock:FlxSprite;
	
    var _standable_objects:FlxGroup;
	
	var Layer:Layers;
	
	var cave_x:Int;
	var cave_y:Int;
	
	override public function create():Void
	{
		super.create();
		FlxNapeSpace.init();
		
		Layer = new Layers();
		_standable_objects = new FlxGroup();
		
		/*functions planned by Fuller*/
		loadBackground();	// everything behind the player scenery wise
		loadMidground();	// everything the player will interact with including the ground
		loadForeground();	// everything that is intended to appear in front of objects in the midground
		
		/* in update(), test if there is collision between the player and the tunnel that marks the end of the level and if the player has "entered" it
		 * and pushed the appropriate key to signify they want to go in to the tunnel. If this trigger happens, load the next level
		 */
		
		
	}

	// written by Fuller
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
        checkPairPressed();		// check if the player is trying to pair themself with the bat again
		if (_bat.isPaired()) movePairTogether();	// if bat is still paired, set _bat.body.velocity = player.body.velocity
        platformTouched();
        applyGravity();
        batPlatformTouched();
        reset();
        nextLevel();
		
	}
	
	// written by Eric
	function loadBackground():Void
	{

		// everything behind the player scenery wise
		/*	Background
		 * 	Glowing rocks (if that happens)
		 * 	Cheeseburgers
		 * 	etc
		 */
        
        var background:FlxSprite; //background variable
        background = new FlxSprite();
        background.loadGraphic("assets/images/Cave_fore_background.png"); //load the background image
        add(background);
		
		
		cave_x = -40;
		cave_y = _ground_height - 160;
		var cave_back:FlxSprite = new FlxSprite(cave_x, cave_y, "assets/images/Cave_tunnel_back.png");
		add(cave_back);
        
        
		
	}
	
	// written by Fuller
	function loadMidground():Void
	{
		// everything the player will interact with including the ground
		/*	Player
		 * 	Bat
		 * 	Ground & Walls (whichever way looks best)
		 * 	Cave tunnel that the player walks into in order to move onto the next level (goes over ground and walls)
		 * 	Interactable objects like gates and buttons (be sure to add() them AFTER the ground!)
		 * 	etc
		 */
		
		// adding objects in this order: light, ground, stepTrigger, player, bat
		
		// add light
		_light = new FlxNapeSprite(625, 350);
		_light.loadGraphic("assets/images/Blue_Light.png");
        _light.createRectangularBody(_light.width / 3.0, _light.height);
		_light.body.allowMovement = false;
        _light.setBodyMaterial(1, 9999999, 9999999, 9999999, 9999999);
		_light.body.shapes.at(0).filter = Layer.light_filter;
		
		// add ground
		var _ground_sprite = new FlxSprite(0, _ground_height-60);
		_ground_sprite.loadGraphic("assets/images/cave_floor_final.png", false);
		
		var _ground = new FlxNapeSprite(512, _ground_height);
		_ground.makeGraphic(1024, 80, FlxColor.BROWN);
        _ground.createRectangularBody(1024, 80);
		_ground.body.allowMovement = false;
		_ground.setBodyMaterial(.945, 9999999, 9999999, 9999999, 9999999); //makes ground immovable
		_ground.body.gravMass = 300000;
		_ground.body.shapes.at(0).filter = Layer.ground_filter; // SETS THE GROUND TO THE CORRECT COLLISION LAYER
		_standable_objects.add(_ground);	// the player can now stand on the ground
        
        //ledge
        var _ground_sprite1 = new FlxSprite(-550, _ground_height-400);
		_ground_sprite1.loadGraphic("assets/images/cave_floor_final.png", false);
		
		var _ground1 = new FlxNapeSprite(-50, _ground_height-340);
		_ground1.makeGraphic(1024, 80, FlxColor.BROWN);
        _ground1.createRectangularBody(1024, 80);
		_ground1.body.allowMovement = false;
		_ground1.setBodyMaterial(.945, 9999999, 9999999, 9999999, 9999999); //makes ground immovable
		_ground1.body.gravMass = 300000;
		_ground1.body.shapes.at(0).filter = Layer.ground_filter; // SETS THE GROUND TO THE CORRECT COLLISION LAYER
		_standable_objects.add(_ground1);	// the player can now stand on the ground
		
		// add bat
		_bat = new Bat(_playerX - 30, _playerY - 64);
		
		// add player
		_player = new Player(_playerX, _playerY, _bat);
		_bat.body.velocity = _player.body.velocity;
		
		// add stepTrigger
		_stepTrigger = new StepTrigger(800, _ground_height - 40 - 6, false, false, "assets/images/blue button 1.png");	// i had to hardcode and guess this location through trial and error. I'm not sure there is a better way
		// it is 390 - 6 because "6" is the height of the step trigger. When we import the sprite for it, this number will have to change to match the sprite
		_standable_objects.add(_stepTrigger);
        
        addBatPlatformAndRock();
        
        //_nextLevelBlock = new FlxSprite(100, 600);
        //_nextLevelBlock.makeGraphic(16,16);
		
		// adding them in this SPECIFIC order so that the player can walk in front of the light, etc. 
		add(_light);
		add(_ground);
		add(_ground_sprite);
        add(_ground1);
		add(_ground_sprite1);
		add(_player);
		add(_stepTrigger);
		add(_bat);
        //add(_nextLevelBlock);
		
		
	}
	
	function loadForeground():Void
	{
		// everything that is intended to appear in front of objects in the midground
		/* 	Stalagtites and stalagmites that the player walks behind
		 *  Other cave features
		 *  "Accessory foreground art" on the Close Out document
		 *  StepTrigger platform
		 */
		
		// front of the cave so that the player can walk behind it
        var cave_front:FlxSprite = new FlxSprite(cave_x, cave_y, "assets/images/Cave_tunnel_front.png");
		add(cave_front);
	}
    
    //written by Eric, modified by Fuller
    function addBatPlatformAndRock():Void
    {
        _batplatform = new FlxNapeSprite(100,100);
        _batplatform.makeGraphic(8,8);
        _batplatform.loadGraphic("assets/images/wallbutton.png", false);
        _batplatform.createRectangularBody();
        _batplatform.setBodyMaterial(9999999,9999999,9999999,9999999,9999999);
        _batplatform.flipX = true;
        
        _gate = new Gate(500, 600, 500, 800, "assets/images/gate.png");
        _gate.body.shapes.at(0).filter = Layer.gate_filter;
        _standable_objects.add(_gate);
        
        _gate1 = new Gate(300, 850, 300, 600, "assets/images/gate.png");
        _gate1.body.shapes.at(0).filter = Layer.gate_filter;
        _standable_objects.add(_gate1);
        
        add(_batplatform);
        add(_gate);
        add(_gate1);
		
		
    }
    
    //written by Eric, modified by Fuller
    function batPlatformTouched():Void
    {
        //if (FlxG.keys.anyPressed([B]) && FlxG.collide(_bat, _batplatform))
		if (FlxG.collide(_bat, _batplatform))
        {
			//FlxG.log.add("Bat is pushing the button");
			if ( !_gate.inMotion() && !_gate1.inMotion())
			{
				
				//FlxG.log.add("_gate.trigger() called");
				_gate.trigger();
                _gate1.trigger();
				//FlxG.log.add("");
			}
            //_batplatform.kill();
        }

    }
    
    public function reset():Void
    {
        if (FlxG.keys.anyPressed([R]))
        {
            FlxG.resetState();
        }
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
				var maxPairingDistance:Float = 100.0;
				//FlxG.log.add("trying to re-pair the two");
				
				// Is it close enough to pair with the player?
				if ( FlxMath.isDistanceWithin(_bat, _player, maxPairingDistance, true) ) 	// yes
				{
					//FlxG.log.add("within distance!");
					//_bat.togglePaired();	
					//	return true;
					if ( (_bat.y + _bat.height / 2.0)  < (_player.y + _player.height * .2) ) // bat is above the player's torso. The bat _should_ never be below the ground anyway though
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
			_player.body.velocity.y += 18;
			
			if (_bat.isPaired())	// move the bat with the player if they are paired
			{
				if ( (_bat.y - _bat.height / 2.0)  < (_player.y - _player.height * .8) ) // bat will stop falling below the player..?
				{
					//FlxG.log.add("Applying gravity to the bat");
					_bat.body.velocity.y += 18;
				}
				else{
					//FlxG.log.add("NOT APPLYING");
				}
			}
		}
	}
	
    
    //written by Fuller
    function platformTouched():Void
    {
		var y:Float = _player.y + _player.height; 		// y position of the player's feet!
		
		var x:Float = _player.x + _player.width / 2; 	// x position of the middle of the player sprite
		
		var x_feet:Float = _player.x + _player.width;	// x position of the player's feet
		if (_player.facing == FlxObject.LEFT)
		{
			x_feet = _player.x;
		}
        
		var _debug_line = new FlxSprite(x, y);
		_debug_line.makeGraphic(1, 1);
		//add(_debug_line);
		
		var trigger_right_x:Float = _stepTrigger.x + _stepTrigger.width;
		
		var p_standing_on:Bool = Math.abs(y - _stepTrigger.y) < 2.0 && _stepTrigger.x <= x  && x <= _stepTrigger.x + _stepTrigger.width;
		var p_from_left:Bool = Math.abs(x_feet - _stepTrigger.x) < 2.0 && y >= _stepTrigger.y;
		var p_from_right:Bool = Math.abs(x_feet - trigger_right_x) < 2.0 && y >= _stepTrigger.y;
		
		var p_triggered:Bool = p_standing_on || p_from_left || p_from_right;	// triggered by the player
		
		var b_triggered:Bool = false;	// triggered by the boulder
		
		var triggered:Bool = p_triggered || b_triggered;
		
		//FlxG.log.add("_from_left: " + _from_left + "\t_from_right: " + _from_right);
		if ( triggered )
		{
			
			// lower the stepTrigger
			if ( !_stepTrigger.isDepressed()  )//&& !_stepTrigger.inMotion() )
			{
				_stepTrigger.lower();
				_light.kill();
				//FlxG.sound.play("assets/sounds/light_click.wav");
				//light_sound.play();
			}
			
		}
		else
		{
			if (_stepTrigger.isDepressed() && !_stepTrigger.inMotion()){
				
				if ( _light.body.space == null)
				{
					// raise the stepTrigger
					_stepTrigger.raise();
					_light.revive();
				}
				
			}
			
		}
		
    }
    
    function nextLevel():Void
    {
		var y:Float = _player.y; 		// y position of the player's feet!
		var x:Float = _player.x + _player.width / 2; 	// x position of the player's feet
        
		FlxG.log.add(x + " and y " + y);
		
		if ( x <= 50 && y >= 510 && _bat.isPaired() )
		{
            FlxG.switchState(new Level4());
		}

    }
	
	
}