package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.masks.Hitbox;

class Treasure extends Entity
{	
	
	private static var itemNames:Array<String> = ["pot", "pile of scrap", "anchor","chest"];
	
	public var weight(default,null):Int;
	public var price(default,null):Int;
	public var descr(default,null):String;
	
	static var maxWeight:Int = 20;
	static var maxPricePerWeight:Int = 60;

	public function new (x:Float, y:Float)
	{
		super(x,y);
		
		var height = cast(HXP.scene, scenes.BoatStage).map.height * cast(HXP.scene, scenes.BoatStage).map.tileHeight;
		var probaWeight = (height - y) / height;
		
		
		// weight = 1 + Std.random(maxWeight);
		weight = Std.int(maxWeight * (0.05 + probaWeight * 1.5*Math.random()));
		price = weight * ( 3 + Std.random(maxPricePerWeight) );
		
		var i = Std.random(itemNames.length);
		price *= Std.int(i/2+1);
		
		descr = ((weight > (i+1)*3) ? "big " : "small ") + itemNames[i];
		
		setHitbox(10,10);
		type = "treasure";
	}
}
