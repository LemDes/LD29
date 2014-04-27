package entities;

import com.haxepunk.Entity;
import com.haxepunk.masks.Hitbox;

class Harbor extends Entity
{
	public function new (x:Float, y:Float, width:Float, height:Float)
	{
		super(x, y);
		
		setHitbox(Std.int(width), Std.int(height));
		type = "harbor";
	}
	
	override public function update ()
	{
		var ship:Ship = cast(scene, scenes.BoatStage).ship;;
		var collideShip = collide("ship", x, y) != null;
		
		if (collideShip != _collideShip)
		{
			trace(collideShip ? "Colliding" : "Not colliding");
			_collideShip = collideShip;
			if(collideShip)
			{
				ship.sell();
			}
		}
	}
	
	var _collideShip : Bool = false;
}
