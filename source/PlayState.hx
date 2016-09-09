package;

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
	
	override public function create():Void
	{
		addPlayerAndBat();
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		checkPairPressed();		// check if the player is trying to pair themself with the bat again
		super.update(elapsed);
	}
	
	
	// written by Fuller
	function addPlayerAndBat():Void 	
	{
		_player = new Player(_playerY, _playerY);
		_bat = new Bat(_playerY-4, _playerY-4);
		
		add(_player);
		add(_bat);
	}
	
	// written by Fuller
	function checkPairPressed():Bool	
	{
		if ( FlxG.keys.justReleased.SPACE)	// by pushing space, the player tries to pair themself back to the bat again
		{
			// should only pair if the bat is within a certain range
			var maxPairingDistance:Int = 30;
			
			// is the bat already paired? If so, then unpair it!
			if (_bat.isPaired()) // unpair
			{	
				_bat.togglePaired();
				return true;
			}
			
			// Is it close enough to pair with the player?
			if ( FlxMath.isDistanceWithin(_player, _bat, maxPairingDistance) ) 	// yes
			{	
				if ( (_bat.y + _bat.height / 2.0)  < (_player.y + _player.height / 2.0) ) // bat is above the player's height. The bat _should_ never be below the ground anyway though
				{
					_bat.togglePaired();	
					return true;
				}
			}			
			// no, it's not close enough. Hits the return statement at the end of the function and returns false
		}
		return false;
	}

}
