package;
/**
 * ...
 * @author Gabe
 */
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
	
	override public function create():Void
	{
		
		super.create();
		FlxNapeSpace.init();
		
		_blocks = new FlxGroup(128);
		
		addFloor(64, 2, 0, 700);
		
		addPlayerAndBat();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		checkPairPressed();		// check if the player is trying to pair themself with the bat again
		applyGravity();
	}
	
	// written by Gabriel, modified by Fuller
	public function applyGravity():Void {
		if (FlxG.collide(_player, _blocks) && _player.canJump())
		{
			_player.body.velocity.y = 0;
			if (! _player.canJump())
			{
				_player.allowJump();
			}
			
		}
		else
		{
			_player.body.velocity.y += 10;
		}
	}
	
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
		_bat = new Bat(_playerX-24, _playerY-8);
		_player = new Player(_playerX, _playerY, _bat);
		
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
