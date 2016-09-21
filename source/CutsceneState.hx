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
		_scene.loadGraphic("assets/images/CutsceneSpriteSheet.png", true, 1024, 720);// , 16, 16);
		
		_scene.animation.add("play", [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7], 2, false);
		
		//_scene.animation.addByStringIndices("play2", "cutScene", ["1", "1T", "2"], ".png", 2, false);
		_scene.animation.play("play");
		
		FlxG.sound.playMusic("assets/music/Theme2.wav");
		
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
