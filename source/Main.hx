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
		addChild(new FlxGame(0, 0, MenuState)); //originally
		//addChild(new FlxGame(512, 360, MenuState));
		
		//addChild(new FlxGame(768, 540, MenuState));
		//FlxG.sound.playMusic("assets/music/theme1.ogg");
	}
}