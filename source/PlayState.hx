package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeVelocity;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class PlayState extends FlxState
{
	var _playerY:Int = 200;
	var _playerX:Int = 20;
	var _player:Player;
	
	var _bat:Bat;
	var _test:FlxNapeSprite;
	
	override public function create():Void
	{
		
		super.create();
	}
	
	override public function create():Void
	{
		
		super.create();
		FlxNapeSpace.init();
		
		_test = new FlxNapeSprite(16, 16);
        _test.makeGraphic(16, 16);
        _test.createRectangularBody();
        _test.body.velocity.x = 5;
		
        add(_test);
		
		// = new Player(_playerY, _playerY);
		//add(_player);
		
		//_bat = new Bat(_playerY - 4, _playerY - 4);
		//add(_bat);
		addPlayerAndBat();
		
		
		
		
	}

	override public function update(elapsed:Float):Void
	{
		//FlxNapeVelocity.moveTowardsMouse(_test, 1);
		checkPairPressed();		// check if the player is trying to pair themself with the bat again
		super.update(elapsed);
	}
	
	
	// written by Fuller
	function addPlayerAndBat():Void 	
	{
		_player = new Player(_playerY, _playerY);
		_bat = new Bat(_playerY-4, _playerY-4);
		
		_bat.setPlayerSpeed(_player.getSpeed());
		
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
