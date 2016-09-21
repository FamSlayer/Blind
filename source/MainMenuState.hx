package;

/**
 * ...
 * @author Fuller Taylor
 */

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import levels.Level0;

class MainMenuState extends FlxState
{
	var _scene:FlxSprite;
	var _testing_phase:Bool = false;
	
	override public function create():Void
	{
		_scene = new FlxSprite();
		_scene.loadGraphic("assets/images/titlescreen.png");// , 16, 16);
		_scene.setGraphicSize(1024, 720);
		_scene.centerOrigin();
		_scene.screenCenter();
	
		add(_scene);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// test if a bunch of buttons were pressed
		var pressed:Bool = false;
		
		// number row
		if (FlxG.keys.anyPressed([ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, BACKSPACE])) pressed = true;
		
		// upper row
		else if (FlxG.keys.anyPressed([TAB, Q, W, E, R, T, Y, U, I, O, P, LBRACKET, RBRACKET, BACKSLASH])) pressed = true;
		
		// home row
		else if (FlxG.keys.anyPressed([CAPSLOCK, A, S, D, F, G, H, J, K, L, SEMICOLON, QUOTE, ENTER] )) pressed = true;
		
		// lower row
		else if (FlxG.keys.anyPressed([SHIFT, Z, X, C, V, B, N, M, COMMA, PERIOD, SLASH])) pressed = true;
		
		// we didn't have a name for this row in my keyboarding class in ELEMENTARY SCHOOL
		else if (FlxG.keys.anyPressed([CONTROL, ALT, SPACE, LEFT, DOWN, UP, RIGHT])) pressed = true;
		
		// num pad? who cares?
		
		
		// are the rest of the keys even worth it? It does say "almost any key..."
		
		
		
		if (pressed){
			//STOP THE MUSIC! or restart it... idk do something that's not the way it is
			FlxG.switchState(new Level0());
		}
	}
}
