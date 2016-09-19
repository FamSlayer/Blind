package;
/*
 * @author
 * Written by: Fuller
 */
import nape.dynamics.InteractionFilter;

class Layers
{
	// collision groups
	static var   player_collision_group:Int =  1;	// 000001
	static var      bat_collision_group:Int =  2;	// 000010
	static var    light_collision_group:Int =  4;	// 000100
	static var  boulder_collision_group:Int =  8;	// 001000
	static var     gate_collision_group:Int = 16;	// 010000
	static var   ground_collision_group:Int = 32;	// 100000
	
	// collision masks
	static var 	  player_collision_mask:Int = 57;	// 111001
	static var 	     bat_collision_mask:Int = 54;	// 110110
	static var 	   light_collision_mask:Int =  6;	// 000110
	static var 	 boulder_collision_mask:Int = 57;	// 111001
	static var 	    gate_collision_mask:Int = 27;	// 011011
	static var 	  ground_collision_mask:Int = 27;	// 011011
	
	
	public var player_filter:InteractionFilter;
	public var bat_filter:InteractionFilter;
	public var light_filter:InteractionFilter;
	public var boulder_filter:InteractionFilter;
	public var gate_filter:InteractionFilter;
	public var ground_filter:InteractionFilter;
	
	
	
	// the filters themselves. Call these
	
	public function new ():Void{
		player_filter = new InteractionFilter (
			player_collision_group, player_collision_mask);
			
		bat_filter = new InteractionFilter (
			bat_collision_group, bat_collision_mask);
			
		light_filter = new InteractionFilter (
			light_collision_group, light_collision_mask);
			
		boulder_filter = new InteractionFilter (
			boulder_collision_group, boulder_collision_mask);
			
		gate_filter = new InteractionFilter (
			gate_collision_group, gate_collision_mask);
			
		ground_filter = new InteractionFilter (
			ground_collision_group, ground_collision_mask);
			
	}	

}