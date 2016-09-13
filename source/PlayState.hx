package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeSpace;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var _playerY:Int = 200;
	var _playerX:Int = 20;
	var _player:Player;
	
	var _bat:Bat;
	var _test:FlxNapeSprite;
    var _platform:FlxNapeSprite;
    var _light:FlxNapeSprite;
    var _batplatform:FlxNapeSprite;
    var _rock:FlxNapeSprite;
	
	override public function create():Void
	{
		
		super.create();
		FlxNapeSpace.init();
		
		_test = new FlxNapeSprite(16, 16);
        _test.makeGraphic(16, 16);
        _test.createRectangularBody();
        _test.body.velocity.x = 5;
        add(_test);
        
		
		
		addPlayerAndBat();
        addPlatformAndLight();
        addBatPlatformAndRock();
		
	}

	override public function update(elapsed:Float):Void
	{
		checkPairPressed();		// check if the player is trying to pair themself with the bat again
        platformTouched();
        batPlatformTouched();
		super.update(elapsed);
	}
    
    //written by Eric
    function addBatPlatformAndRock():Void
    {
        _batplatform = new FlxNapeSprite(800,100);
        _batplatform.makeGraphic(8,8);
        _batplatform.createRectangularBody();
        _batplatform.setBodyMaterial(9999999,9999999,9999999,9999999,9999999);
        
        _rock = new FlxNapeSprite(800,200);
        _rock.makeGraphic(64,64);
        _rock.createRectangularBody(); 
        _rock.setBodyMaterial(9999999,9999999,9999999,9999999,9999999);
        
        add(_batplatform);
        add(_rock);
    }
    
    //written by Eric
    function addPlatformAndLight():Void
    {
        _platform = new FlxNapeSprite(400,214);
        _platform.makeGraphic(32,8);
        _platform.createRectangularBody();
        _platform.setBodyMaterial(9999999,9999999,9999999,9999999,9999999);
        
        _light = new FlxNapeSprite(400,100);
		_light.makeGraphic(32, 32, FlxColor.YELLOW);
        _light.createRectangularBody();
        _light.setBodyMaterial(9999999,9999999,9999999,9999999,9999999);
        
        add(_light);
        add(_platform);
    }
    
    //written by Eric
    function platformTouched():Void
    {
        if (FlxG.keys.anyPressed([P]) && FlxG.collide(_player, _platform))
        {
            _light.kill();
            _platform.kill();
        }
    }
    
    //written by Eric
    function batPlatformTouched():Void
    {
        if (FlxG.keys.anyPressed([B]) && FlxG.collide(_bat, _batplatform))
        {
            _rock.kill();
            _batplatform.kill();
        }
    }
	
	
	// written by Fuller
	function addPlayerAndBat():Void 	
	{
		_player = new Player(_playerY, _playerY);
		_bat = new Bat(_playerY-4, _playerY-4);
		
		_bat.setPlayerSpeed(_player.getSpeed());
		
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
				var maxPairingDistance:Float = 100.0;
				
				// Is it close enough to pair with the player?
				if ( FlxMath.isDistanceWithin(_bat, _player, maxPairingDistance) ) 	// yes
				{
					
					if ( (_bat.y + _bat.height / 2.0)  < (_player.y + _player.height / 2.0) ) // bat is above the player's height. The bat _should_ never be below the ground anyway though
					{
						
					//}
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
