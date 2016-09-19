package levels;

/*
 * @authors
 * Template written by: Fuller
 * 
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
    var _player:Player;
	var _bat:Bat;
	var _standable_objects:FlxGroup;
	var Layer:Layers;
	
	override public function create():Void
	{
		super.create();
		FlxNapeSpace.init();
		
		Layer = new Layers();
		
		/*functions planned by Fuller*/
		loadBackground();	// everything behind the player scenery wise
		loadMidground();	// everything the player will interact with including the ground
		loadForeground();	// everything that is intended to appear in front of objects in the midground
		
		/* in update(), test if there is collision between the player and the tunnel that marks the end of the level and if the player has "entered" it
		 * and pushed the appropriate key to signify they want to go in to the tunnel. If this trigger happens, load the next level
		 */
		
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
        applyGravity();
        checkPairPressed();		// check if the player is trying to pair themself with the bat again
		if (_bat.isPaired()) movePairTogether();	// if bat is still paired, set _bat.body.velocity = player.body.velocity
        reset();
		
	}
    
    
	
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
        addGround(); //function to add the ground
        addPlayerAndBat();
        addPlatformAndLight();
        addBoulder();
		
		
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
    
    
    function addGround():Void
    {
        var _temp_ground:FlxNapeSprite;
		_temp_ground = new FlxNapeSprite(150, 400);
        _temp_ground.makeGraphic(500, 20, FlxColor.BROWN);
        _temp_ground.createRectangularBody();
		_temp_ground.body.allowMovement = false;
		_temp_ground.body.allowRotation = false;
		_temp_ground.setBodyMaterial(.945, 9999999, 9999999, 9999999, 9999999);
		_temp_ground.body.gravMass = 300000;
		
		Layer = new Layers();
		_temp_ground.body.shapes.at(0).filter = Layer.ground_filter; // SETS THE GROUND TO THE CORRECT COLLISION LAYER
		
        //_temp_ground.body.velocity.x = 5;
        add(_temp_ground);
		
		_standable_objects = new FlxGroup();
		_standable_objects.add(_temp_ground);
        
        var _temp_wall:FlxNapeSprite;
        _temp_wall = new FlxNapeSprite(410, 370);
        _temp_wall.makeGraphic(20,80, FlxColor.BROWN);
        _temp_wall.createRectangularBody();
        _temp_wall.body.allowMovement = false;
        _temp_wall.body.allowRotation = false;
        _temp_wall.setBodyMaterial(.945,9999999, 9999999, 9999999, 9999999);
        _temp_wall.body.gravMass = 300000;
        add(_temp_wall);
        
        var _temp_ground1:FlxNapeSprite;
        _temp_ground1 = new FlxNapeSprite(750, 340);
        _temp_ground1.makeGraphic(700, 20, FlxColor.BROWN);
        _temp_ground1.createRectangularBody();
		_temp_ground1.body.allowMovement = false;
		_temp_ground1.body.allowRotation = false;
		_temp_ground1.setBodyMaterial(.945, 9999999, 9999999, 9999999, 9999999);
		_temp_ground1.body.gravMass = 300000;
		
		Layer = new Layers();
		_temp_ground.body.shapes.at(0).filter = Layer.ground_filter; // SETS THE GROUND TO THE CORRECT COLLISION LAYER
		
        //_temp_ground.body.velocity.x = 5;
        add(_temp_ground1);
		

		_standable_objects.add(_temp_ground1);
    }
    
    function addBoulder():Void
    {
        var _boulder:FlxNapeSprite; //initialize ground as nape
        _boulder = new FlxNapeSprite(200, 400);
        //_temp_ground.makeGraphic(1100, 20, FlxColor.BROWN);
        _boulder.loadGraphic("assets/images/boulder.png"); //load the floor image
        _boulder.createCircularBody(16);
		_boulder.body.allowMovement = true;
		_boulder.body.allowRotation = false;
		_boulder.setBodyMaterial(0.1, 900, 900, 900, 900); //makes ground immovable
		_boulder.body.gravMass = 3000;
		
		Layer = new Layers(); 
		_boulder.body.shapes.at(0).filter = Layer.boulder_filter; // SETS THE GROUND TO THE CORRECT COLLISION LAYER
		
        //_temp_ground.body.velocity.x = 5;
        add(_boulder);

    }
    
        	// written by Fuller
	function addPlayerAndBat():Void 	
	{
        var _playerY:Int = 200;
	    var _playerX:Int = 20;
        
		_bat = new Bat(_playerY-24, _playerY-8);
		_player = new Player(_playerY, _playerY, _bat);
		
		_bat.body.velocity = _player.body.velocity;
		
		add(_player);
		add(_bat);
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
    
    function addPlatformAndLight():Void
    {
        
        var _platform:StepTrigger;
        var _platform1:StepTrigger;
        var _light:FlxNapeSprite;
        var _light1:FlxNapeSprite;
        
		_light = new FlxNapeSprite(600, 100);
		_light.makeGraphic(32, 4);
        _light.createRectangularBody();
        _light.setBodyMaterial(9999999, 9999999, 9999999, 9999999, 9999999);
		
        _light1 = new FlxNapeSprite(800, 100);
		_light1.makeGraphic(32, 4, FlxColor.BLUE);
        _light1.createRectangularBody();
        _light1.setBodyMaterial(9999999, 9999999, 9999999, 9999999, 9999999);
		
        //_platform = new StepTrigger(400, 390 - 6);	// i had to hardcode and guess this location through trial and error. I'm not sure there is a better way
		// it is 390 - 6 because "6" is the height of the step trigger. When we import the sprite for it, this number will have to change to match the sprite
        
        _platform = new StepTrigger(100, 385); //changed this number after adding floor png asset
        
        _platform1 = new StepTrigger(300, 385);
        
        _platform.body.shapes.at(0).filter = Layer.ground_filter; // SETS THE GROUND TO THE CORRECT COLLISION LAYER
        
        add(_light);
        add(_platform);
        add(_light1);
        add(_platform1);
        
		_standable_objects.add(_platform);
        _standable_objects.add(_platform1);
    }
    

	
	
	
}