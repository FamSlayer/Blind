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

class Level2 extends FlxState
{
	var _playerY:Int = 560;
	var _playerX:Int = 80;
	var _ground_height:Int = 680;
    var _player:Player;
	var _bat:Bat;
    var _batplatform:FlxNapeSprite;
    var _gate:Gate;
	
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
        applyGravity();
        batPlatformTouched();
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
		
		
		// add ground
        //this is the ground the player starts on
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
		
        //this is the bottom part of the upper ledge
        var _ground_sprite1 = new FlxSprite(-475, _ground_height-300);
		_ground_sprite1.loadGraphic("assets/images/cave_floor_final.png", false);
		
		var _ground1 = new FlxNapeSprite(24, _ground_height-240);
		_ground1.makeGraphic(1024, 80, FlxColor.BROWN);
        _ground1.createRectangularBody(1024, 80);
		_ground1.body.allowMovement = false;
		_ground1.setBodyMaterial(.945, 9999999, 9999999, 9999999, 9999999); //makes ground immovable
		_ground1.body.gravMass = 300000;
		_ground1.body.shapes.at(0).filter = Layer.ground_filter; // SETS THE GROUND TO THE CORRECT COLLISION LAYER
		_standable_objects.add(_ground1);	// the player can now stand on the ground
        
        //this is the top part of the upper ledge (where the portal is)
        var _ground_sprite2 = new FlxSprite(-550, _ground_height-360);
		_ground_sprite2.loadGraphic("assets/images/cave_floor_final.png", false);
		
		var _ground2 = new FlxNapeSprite(-50, _ground_height-300);
		_ground2.makeGraphic(1024, 80, FlxColor.BROWN);
        _ground2.createRectangularBody(1024, 80);
		_ground2.body.allowMovement = false;
		_ground2.setBodyMaterial(.945, 9999999, 9999999, 9999999, 9999999); //makes ground immovable
		_ground2.body.gravMass = 300000;
		_ground2.body.shapes.at(0).filter = Layer.ground_filter; // SETS THE GROUND TO THE CORRECT COLLISION LAYER
		_standable_objects.add(_ground2);	// the player can now stand on the ground
        
        
        //this is the ground on the far right
        var _ground_sprite3 = new FlxSprite(800, _ground_height-120);
		_ground_sprite3.loadGraphic("assets/images/cave_floor_final.png", false);
		
		var _ground3 = new FlxNapeSprite(1324, _ground_height-60);
		_ground3.makeGraphic(1024, 80, FlxColor.PURPLE);
        _ground3.createRectangularBody(1024, 80);
		_ground3.body.allowMovement = false;
		_ground3.setBodyMaterial(.945, 9999999, 9999999, 9999999, 9999999); //makes ground immovable
		_ground3.body.gravMass = 300000;
		_ground3.body.shapes.at(0).filter = Layer.ground_filter; // SETS THE GROUND TO THE CORRECT COLLISION LAYER
		_standable_objects.add(_ground3);	// the player can now stand on the ground
        
		// add bat
		_bat = new Bat(_playerX - 30, _playerY - 64);
		
		// add player
		_player = new Player(_playerX, _playerY, _bat);
		_bat.body.velocity = _player.body.velocity;
		

        addBatPlatformAndRock();

		add(_ground);
		add(_ground_sprite);
        add(_ground1);
		add(_ground_sprite1);
        add(_ground2);
		add(_ground_sprite2);
        add(_ground3);
		add(_ground_sprite3);
		add(_player);
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
    
    public function reset():Void
    {
        if (FlxG.keys.anyPressed([R]))
        {
            FlxG.resetState();
        }
    }
    
    //written by Eric, modified by Fuller
    function addBatPlatformAndRock():Void
    {
        _batplatform = new FlxNapeSprite(800,100);
        _batplatform.makeGraphic(8,8);
        _batplatform.createRectangularBody();
        _batplatform.setBodyMaterial(9999999,9999999,9999999,9999999,9999999);
        
        
        _gate = new Gate(450, 460, 700, 460, 60, 15);//, "assets/images/platform.png");
        _gate.body.shapes.at(0).filter = Layer.gate_filter;
        _standable_objects.add(_gate);
        
        add(_batplatform);
        add(_gate);
		
		
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
    function nextLevel():Void
    {
		var y:Float = _player.y + _player.height; 		// y position of the player's feet!
		var x:Float = _player.x + _player.width / 2; 	// x position of the player's feet
        
		//FlxG.log.add("Y: " + y + "\tPlatform.y: " + _stepTrigger.y);
		
		if ( 50 <= x  && x <= 100 && 250 <= y && y <= 350 )
		{
            FlxG.switchState(new Level3());
		}

    }
	
    
	
	
}