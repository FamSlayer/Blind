package;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeVelocity;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.group.FlxGroup;

class GravityState extends FlxState
{
	var _playerY:Int = 200;
	var _playerX:Int = 20;
	var _player:Player;
	
	var _blocks:FlxGroup;
	
	var _bat:Bat;
	var _test:FlxNapeSprite;
	
	override public function create():Void
	{
		
		super.create();
		FlxNapeSpace.init();
		
		_blocks = new FlxGroup(128);
		
		addFloor(32, 2, 0, 700);
		addFloor(24, 2, 512+16*12, 700);
		
		addPlayerAndBat();
		
		FlxG.sound.playMusic("wind", 1, true);
	}

	override public function update(elapsed:Float):Void
	{
		//FlxNapeVelocity.moveTowardsMouse(_test, 1);
		checkPairPressed();		// check if the player is trying to pair themself with the bat again
		super.update(elapsed);
		gravity();
		FlxG.collide(_blocks, _player);
	}
	
	// written by Gabriel
	public function gravity():Void {
		if (!FlxG.collide(_player, _blocks) && _player._jumped) {
			_player.body.velocity.y += 10;
		} else if (!_player._up){
			_player.body.velocity.y = 0;
			_player._jumped = false;
		}
	}
	
	// written by Gabriel
	public function addFloor(W:Int, H:Int, X:Int, Y:Int):Void {
		for (i in 0...W) {
			for (u in 0...H) {
				var b:Block = new Block(X + i * 16, Y + u * 16);
				_blocks.add(b);
			}
		}
		add(_blocks);
	}
	
	// written by Fuller
	function addPlayerAndBat():Void 	
	{
		_player = new Player(_playerX, _playerY);
		_bat = new Bat(_playerX-4, _playerY-4);
		
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
