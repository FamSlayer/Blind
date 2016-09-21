package;

/**
 * ...
 * @author Fuller Taylor
 */

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import levels.Level0;

class CutsceneState extends FlxState
{
	var _scene:FlxSprite;
	var _testing_phase:Bool = false;
	
	override public function create():Void
	{
		_scene = new FlxSprite();
		_scene.loadGraphic("assets/images/CutsceneSpriteSheet_Final.png", true, 1024, 720);// , 16, 16);
		
		_scene.animation.add("play", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 2, false);
		
		_scene.animation.play("play");
		
		add(_scene);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (_scene.animation.finished)
		{
			if (_testing_phase) FlxG.switchState(new MenuState());
			else FlxG.switchState(new MainMenuState());
		}
	}
}
