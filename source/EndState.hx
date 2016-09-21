package;

/**
 * ...
 * @author Fuller Taylor
 */

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class EndState extends FlxState
{
	var _scene:FlxSprite;
	var _testing_phase:Bool = false;
	
	override public function create():Void
	{
		_scene = new FlxSprite();
		_scene.loadGraphic("assets/images/Cave_Win_Screen.png", true, 1024, 720);// , 16, 16);
		
		add(_scene);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		
		var pressed:Bool = false;
		
		// number row
		if (FlxG.keys.anyJustPressed([ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, BACKSPACE])) pressed = true;
		
		// upper row
		else if (FlxG.keys.anyJustPressed([TAB, Q, W, E, R, T, Y, U, I, O, P, LBRACKET, RBRACKET, BACKSLASH])) pressed = true;
		
		// home row
		else if (FlxG.keys.anyJustPressed([CAPSLOCK, A, S, D, F, G, H, J, K, L, SEMICOLON, QUOTE, ENTER] )) pressed = true;
		
		// lower row
		else if (FlxG.keys.anyJustPressed([SHIFT, Z, X, C, V, B, N, M, COMMA, PERIOD, SLASH])) pressed = true;
		
		// we didn't have a name for this row in my keyboarding class in ELEMENTARY SCHOOL
		else if (FlxG.keys.anyJustPressed([CONTROL, ALT, SPACE, LEFT, DOWN, UP, RIGHT])) pressed = true;
		
		if (pressed)
		{
			FlxG.switchState(new MainMenuState());
		}
	}
}
