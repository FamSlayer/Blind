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
import Layers;

class Level1 extends FlxState
{
	var _playerY:Int = 560;
	var _playerX:Int = 80;
	var _ground_height:Int = 660;
    var _player:Player;
	var _bat:Bat;
    var _light:FlxNapeSprite;
    var _light1:FlxNapeSprite;
	var _stepTrigger:StepTrigger;
    var _stepTrigger1:StepTrigger;
    var _boulder:Block;
	
    var _standable_objects:FlxGroup;
	
	var Layer:Layers;
	
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
        platform1Touched();
        applyGravity();
        reset();
		
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
		_light = new FlxNapeSprite(700, 450);
		_light.makeGraphic(32, 800, FlxColor.YELLOW);
        _light.createRectangularBody();
		_light.body.allowMovement = false;
        _light.setBodyMaterial(1, 9999999, 9999999, 9999999, 9999999);
		_light.body.shapes.at(0).filter = Layer.light_filter;
        
        // add another light
		_light1 = new FlxNapeSprite(800, 450);
		_light1.makeGraphic(32, 800, FlxColor.PINK);
        _light1.createRectangularBody();
		_light1.body.allowMovement = false;
        _light1.setBodyMaterial(1, 9999999, 9999999, 9999999, 9999999);
		_light1.body.shapes.at(0).filter = Layer.light_filter;
		
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
		_stepTrigger = new StepTrigger(200, _ground_height - 30 - 6, false, false, "assets/images/blue button 1.png");	// i had to hardcode and guess this location through trial and error. I'm not sure there is a better way
		// it is 390 - 6 because "6" is the height of the step trigger. When we import the sprite for it, this number will have to change to match the sprite
		_standable_objects.add(_stepTrigger);
        
        // add another stepTrigger
		_stepTrigger1 = new StepTrigger(400, _ground_height - 30 - 6, false, false, "assets/images/green button 1.png");	// i had to hardcode and guess this location through trial and error. I'm not sure there is a better way
		// it is 390 - 6 because "6" is the height of the step trigger. When we import the sprite for it, this number will have to change to match the sprite
		_standable_objects.add(_stepTrigger1);
        
        //add boulder
        var _boulder = new FlxNapeSprite(300, _ground_height);
        _boulder.loadGraphic("assets/images/boulder.png", false);
		_boulder.body.shapes.at(0).filter = Layer.boulder_filter;
        _boulder.createRectangularBody();
		_boulder.body.allowMovement = true;
        _boulder.setBodyMaterial(1, 99, 99, 99, 99);
		_boulder.body.shapes.at(0).filter = Layer.boulder_filter;
		
		add(_light);
        add(_light1);
		add(_ground);
		add(_ground_sprite);
        add(_ground1);
		add(_ground_sprite1);
		add(_player);
		add(_stepTrigger);
        add(_stepTrigger1);
		add(_bat);
        add(_boulder);
		
		
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
			_player.body.velocity.y += 11;
			
			if (_bat.isPaired())	// move the bat with the player if they are paired
			{
				if ( (_bat.y - _bat.height / 2.0)  < (_player.y - _player.height * .8) ) // bat will stop falling below the player..?
				{
					//FlxG.log.add("Applying gravity to the bat");
					_bat.body.velocity.y += 11;
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
    
    //written by Fuller
    function platform1Touched():Void
    {
		var y:Float = _player.y + _player.height; 		// y position of the player's feet!
		var x:Float = _player.x + _player.width / 2; 	// x position of the player's feet
        
		//FlxG.log.add("Y: " + y + "\tPlatform.y: " + _stepTrigger.y);
		
		if (  Math.abs(y - _stepTrigger1.y) < .5 && _stepTrigger1.x <= x  && x <= _stepTrigger1.x + _stepTrigger1.width )
		{
			
			//FlxG.log.add("collision");
			
            _light1.kill();
		}
		else
		{
			if (_light1.body.space == null)		// what ".kill()" does is call the parent's kill() and delete the rigidbody
				// I HOPE that the only time the body.space will be nulled out is after a kill call, and I THINK that'll be true!
				// otherwise, create a boolean variable that just keeps track of whether the object is deleted or not!
			{
				_light1.revive();
			}
            
		}
    }
	
	
}