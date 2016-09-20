package;

/**
 * ...
 * @author Fuller Taylor
 */

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

import levels.Level0;
import levels.Level1;
import levels.Level2;
import levels.Level3;
import levels.Level4;
import levels.Level5;

class MenuState extends FlxState
{
	var _playButton:FlxButton;
	
	override public function create():Void
	{
		// add(new FlxText(10,10,20, "Hello, world!"));
		_playButton  = new FlxButton(0,0, "P L A Y", clickPlay);
		_playButton.screenCenter();
		add(_playButton);
		
		var grav_button = new FlxButton(360, 600, "Gravity", loadGrav);
		add(grav_button);
		
		var _button0 = new FlxButton(576, 256 + 0 * 24, " Demo: Level " + 0,  loadLevel0);
		var _button1 = new FlxButton(576, 256 + 1 * 24, " Demo: Level " + 1,  loadLevel1);
		var _button2 = new FlxButton(576, 256 + 2 * 24, " Demo: Level " + 2,  loadLevel2);
		var _button3 = new FlxButton(576, 256 + 3 * 24, " Demo: Level " + 3,  loadLevel3);
		var _button4 = new FlxButton(576, 256 + 4 * 24, " Demo: Level " + 4,  loadLevel4);
		var _button5 = new FlxButton(576, 256 + 5 * 24, " Demo: Level " + 5,  loadLevel5);
		
		add(_button0);
		add(_button1);
		add(_button2);
		add(_button3);
		add(_button4);
		add(_button5);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	function loadGrav():Void 
	{
		FlxG.switchState(new GravityState());
	}
	
	function loadLevel0():Void
	{
		FlxG.switchState(new Level0());
	}
	
	function loadLevel1():Void
	{
		FlxG.switchState(new Level1());
	}
	
	function loadLevel2():Void
	{
		FlxG.switchState(new Level2());
	}
	
	function loadLevel3():Void
	{
		FlxG.switchState(new Level3());
	}
	
	function loadLevel4():Void
	{
		FlxG.switchState(new Level4());
	}
	
	function loadLevel5():Void
	{
		FlxG.switchState(new Level5());
	}
	
		
	function clickPlay():Void
	{
		// switch to play scene!
		FlxG.switchState(new TestingState());
	}
}