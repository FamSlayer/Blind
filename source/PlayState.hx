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

import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;

class PlayState extends FlxState
{
	var _playerY:Int = 200;
	var _playerX:Int = 20;
	var _player:Player;
	var playerBody:Body;
	var playerShape:Polygon;
	
	var _bat:Bat;
	var _test:FlxNapeSprite;
	
	var gravity:Vec2;
	var space:Space;
	
	override public function create():Void
	{
		
		super.create();
		FlxNapeSpace.init();
		
		gravity = new Vec2(0, 600);
		space = new Space(gravity);
		
		//addFloor(W,H,X,Y)
		addFloor(1024,16,512,526);
		
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
	
	// written by Gabriel
	function addFloor(W:Int,H:Int,X:Int,Y:Int):Void {
		var floorBody:Body = new Body(BodyType.STATIC);
		var floorShape:Polygon = new Polygon(Polygon.box(W, H));
		floorShape.body = floorBody;
		floorBody.space = space;
		floorBody.position.setxy(X, Y);
		floorBody.allowMovement = false;
		var floorSprite = new FlxNapeSprite(X,Y);
		floorSprite.makeGraphic(W, H, FlxColor.RED);
		floorSprite.createRectangularBody();
		add(floorSprite);
	}
	
	// written by Fuller and Gabriel
	function addPlayerAndBat():Void 	
	{
		_player = new Player(_playerY, _playerY);
		_bat = new Bat(_playerY-4, _playerY-4);
		
		_bat.setPlayerSpeed(_player.getSpeed());
		
		// physics for player
		playerBody = new Body(BodyType.DYNAMIC);
		playerShape = new Polygon(Polygon.box(16,28));
		playerShape.body = playerBody;
		playerBody.space = space;
		playerBody.position.setxy(_playerX, _playerY);
		playerBody.gravMass = 55;
		
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
