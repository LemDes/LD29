package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.masks.Hitbox;

class Treasure extends Entity
{	
	
	public var weight(default,null):Int;
	public var price(default,null):Int;
	
	static var maxWeight:Int = 20;
	static var maxPricePerWeight:Int = 200;

	public function new (x:Int, y:Int)
	{
		super(x,y);
		
		weight = 1 + Std.random(maxWeight);
		price = weight * Std.random(maxPricePerWeight);
		
		setHitbox(10,10);
		type = "treasure";
	}
}
