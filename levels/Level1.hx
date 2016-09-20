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
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.FlxObject;
import Layers;

class Level1 extends FlxState
{
	var _playerY:Int = 560;
	var _playerX:Int = 80;
	var _ground_height:Int = 680;
    var _player:Player;
	var _bat:Bat;
    var _lightA:FlxNapeSprite;
    var _lightB:FlxNapeSprite;
	var _stepTriggerA:StepTrigger;
    var _stepTriggerB:StepTrigger;
    var _boulder:FlxNapeSprite;
	
    var _standable_objects:FlxGroup;
	
	var Layer:Layers;
	
	var _debug_line:FlxSprite;
	
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
        platformTouched(_stepTriggerA, _lightA);
		platformTouched(_stepTriggerB, _lightB);
        //platform1Touched();
        applyGravity();
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
		_lightA = new FlxNapeSprite(600, 450);
		_lightA.loadGraphic("assets/images/Blue_Light.png");
        _lightA.createRectangularBody();
		_lightA.body.allowMovement = false;
        _lightA.setBodyMaterial(1, 9999999, 9999999, 9999999, 9999999);
		_lightA.body.shapes.at(0).filter = Layer.light_filter;
        
        // add another light
		_lightB = new FlxNapeSprite(800, 450);
		_lightB.loadGraphic("assets/images/Green_Light.png");
        _lightB.createRectangularBody();
		_lightB.body.allowMovement = false;
        _lightB.setBodyMaterial(1, 9999999, 9999999, 9999999, 9999999);
		_lightB.body.shapes.at(0).filter = Layer.light_filter;
		
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
        
        var _ground_sprite1 = new FlxSprite(500, _ground_height-120);
		_ground_sprite1.loadGraphic("assets/images/cave_floor_final.png", false);
		
		var _ground1 = new FlxNapeSprite(1024, _ground_height-60);
		_ground1.makeGraphic(1024, 80, FlxColor.PURPLE);
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
		_stepTriggerA = new StepTrigger(200, _ground_height - 40 - 6, false, false, "assets/images/blue button 1.png");	// i had to hardcode and guess this location through trial and error. I'm not sure there is a better way
		// it is 390 - 6 because "6" is the height of the step trigger. When we import the sprite for it, this number will have to change to match the sprite
		_standable_objects.add(_stepTriggerA);
        
        // add another stepTrigger
		_stepTriggerB = new StepTrigger(400, _ground_height - 40 - 6, false, false, "assets/images/green button 1.png");	// i had to hardcode and guess this location through trial and error. I'm not sure there is a better way
		// it is 390 - 6 because "6" is the height of the step trigger. When we import the sprite for it, this number will have to change to match the sprite
		_standable_objects.add(_stepTriggerB);
        
        //add boulder
        _boulder = new FlxNapeSprite(300, _ground_height, "assets/images/boulder.png", false, true);
        _boulder.createCircularBody(30);
		_boulder.body.allowMovement = true;
		_boulder.body.allowRotation = true;
		_boulder.setDrag(40, 10);
        _boulder.setBodyMaterial(.945, 2000, 0.4, 1, 0.05);
		_boulder.body.gravMass = 2000;
		_boulder.body.shapes.at(0).filter = Layer.boulder_filter;
		_standable_objects.add(_boulder);
		
		add(_lightA);
        add(_lightB);
		add(_ground);
		add(_ground_sprite);
        add(_ground1);
		add(_ground_sprite1);
		add(_player);
		add(_stepTriggerA);
        add(_stepTriggerB);
        add(_boulder);
		add(_bat);
		
		
	}
	
	function loadForeground():Void
	{
		// everything that is intended to appear in front of objects in the midground
		/* 	Stalagtites and stalagmites that the player walks behind
		 *  Other cave features
		 *  "Accessory foreground art" on the Close Out document
		 *  StepTrigger platform
		 */
	}
    
	// written by Eric
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
    
    // written by Gabriel, modified & fixed by Fuller (changed gravity functionality, added gravity for the bat when they are paired, added boulder)
	public function applyGravity():Void {
		
		// player gravity with ground
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
		
		
		
		//boulder gravity, added by Fuller
		if (FlxG.collide(_boulder, _standable_objects))
		{
			_boulder.body.velocity.y = 0;
		}
		else
		{
			_boulder.body.velocity.y += 18;
		}
		
	}
	
    
    // written by Fuller
    function platformTouched(_stepTrigger:StepTrigger, _light:FlxNapeSprite):Void
    {
		// LOGIC TO DETERMINE IF THE PLAYER IS TRIGGERING THE STEPTRIGGER
		var y:Float = _player.y + _player.height; 		// y position of the player's feet!
		var x:Float = _player.x + _player.width / 2.0; 	// x position of the middle of the player sprite
		var x_feet:Float = _player.x + _player.width;	// x position of the player's feet
		if (_player.facing == FlxObject.LEFT)
		{
			x_feet = _player.x;
		}
        
		var trigger_right_x:Float = _stepTrigger.x + _stepTrigger.width;
		
		var p_standing_on:Bool = Math.abs(y - _stepTrigger.y) < 2.0 && _stepTrigger.x <= x  && x <= _stepTrigger.x + _stepTrigger.width;
		var p_from_left:Bool = Math.abs(x_feet - _stepTrigger.x) < 2.0 && y >= _stepTrigger.y;
		var p_from_right:Bool = Math.abs(x_feet - trigger_right_x) < 2.0 && y >= _stepTrigger.y;
		
		var p_triggered:Bool = p_standing_on || p_from_left || p_from_right;	// triggered by the player
		
		
		// LOGIC TO DETERMINE IF THE BOULDER IS TRIGGERING THE STEPTRIGGER
		var y:Float = _boulder.y + _boulder.height;
		var x:Float = _boulder.x + _boulder.width / 2.0;		// should be where the bottom of the boulder touches the ground
		var b_x_right:Float = _boulder.x + _boulder.width * .9;	// right part of boulder collision
		var b_x_left:Float = _boulder.x + _boulder.width * .1;	// left part of boulder collision
		
		_debug_line = new FlxSprite(b_x_left, y);
		_debug_line.makeGraphic(1, 1);
		//add(_debug_line);
		
		
		
		
		var b_standing_on:Bool = Math.abs(y - _stepTrigger.y) < 2.0 && _stepTrigger.x <= x && x <= _stepTrigger.x + _stepTrigger.width;
		var b_from_left:Bool = Math.abs(b_x_right - _stepTrigger.x) < 2.0 && y >= _stepTrigger.y;
		var b_from_right:Bool = Math.abs(b_x_left - _stepTrigger.x) < 2.0 && y >= _stepTrigger.y;
		
		
		/* ALSO, if the boulder has triggered the platform, we should slow it's horizontal movement so it stops on the trigger, aka apply our own decelleration?
		 * Additionally, the stepTrigger is being moved as well, so it's horizontal movement should be zeroed out
		 * 
		 */
		
		
		
		var b_triggered:Bool = b_standing_on || b_from_left || b_from_right;	// triggered by the boulder
		
		if (b_triggered)
		{
			_boulder.body.velocity.setxy(0, 0);
			_boulder.body.angularVel = 0;
			FlxG.log.add(_stepTrigger.body.position);
		}
		
		var triggered:Bool = p_triggered || b_triggered;
		
		//FlxG.log.add(_stepTrigger.body.velocity.x);
		
		//FlxG.log.add("_from_left: " + _from_left + "\t_from_right: " + _from_right);
		if ( triggered )
		{
			// zero out the platforms horizontal movement
			//_stepTrigger.body.velocity.x = 0;
			
			// lower the stepTrigger
			if ( !_stepTrigger.isDepressed()  )//&& !_stepTrigger.inMotion() )
			{
				_stepTrigger.lower();
				_light.kill();
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
		var y:Float = _player.y;
		var x:Float = _player.x;
		
        
		if ( 950 <= x && x <= 1000 && y >= 450)
		{
            FlxG.switchState(new Level2());
		}

    }
	
	
}