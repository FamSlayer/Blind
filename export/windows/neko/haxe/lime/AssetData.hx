package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("bat_squeak", "assets//sounds/bat_squeak.wav");
			type.set ("bat_squeak", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("fast_wings", "assets//sounds/fast_wings.wav");
			type.set ("fast_wings", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("footstep", "assets//sounds/footstep.wav");
			type.set ("footstep", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("light_click", "assets//sounds/light_click.wav");
			type.set ("light_click", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("splash", "assets//sounds/splash.wav");
			type.set ("splash", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("stone_door", "assets//sounds/stone_door.wav");
			type.set ("stone_door", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("water_deep_drop", "assets//sounds/water_deep_drop.wav");
			type.set ("water_deep_drop", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("water_droplet", "assets//sounds/water_droplet.wav");
			type.set ("water_droplet", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("wind", "assets//sounds/wind.wav");
			type.set ("wind", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("wings", "assets//sounds/wings.wav");
			type.set ("wings", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("flixel/sounds/beep.ogg", "flixel/sounds/beep.ogg");
			type.set ("flixel/sounds/beep.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("flixel/sounds/flixel.ogg", "flixel/sounds/flixel.ogg");
			type.set ("flixel/sounds/flixel.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("flixel/fonts/nokiafc22.ttf", "flixel/fonts/nokiafc22.ttf");
			type.set ("flixel/fonts/nokiafc22.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			path.set ("flixel/fonts/monsterrat.ttf", "flixel/fonts/monsterrat.ttf");
			type.set ("flixel/fonts/monsterrat.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			path.set ("flixel/images/ui/button.png", "flixel/images/ui/button.png");
			type.set ("flixel/images/ui/button.png", Reflect.field (AssetType, "image".toUpperCase ()));
			
			
			initialized = true;
			
		} //!initialized
		
	} //initialize
	
	
} //AssetData
