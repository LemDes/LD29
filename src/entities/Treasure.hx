package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.masks.Hitbox;

class Treasure extends Entity
{	
	
	private static var itemNames:Array<String> = ["pot", "pile of scrap","chest", "anchor"];
	
	public var weight(default,null):Int;
	public var price(default,null):Int;
	public var descr(default,null):String;
	
	static var maxWeight:Int = 20;
	static var maxPricePerWeight:Int = 60;

	public function new (x:Int, y:Int)
	{
		super(x,y);
		
		weight = 1 + Std.random(maxWeight);
		price = weight * Std.random(maxPricePerWeight);
		
		var i = Std.random(itemNames.length-1);
		
		descr = ((weight > (i+1)*3) ? "big " : "small ") + itemNames[i];
		
		setHitbox(10,10);
		type = "treasure";
	}
}
