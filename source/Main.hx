package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;
import flixel.FlxG;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, CutsceneState));//MenuState)); //originally
		//addChild(new FlxGame(0, 0, MenuState));
	}
}