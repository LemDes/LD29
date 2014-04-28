package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
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
		var ship:Ship = cast(scene, scenes.BoatStage).ship;
		var collideShip = collide("ship", x, y) != null;
		
		if (collideShip != _collideShip)
		{
			_collideShip = collideShip;
			
			if(collideShip)
			{
				ship.sell();
				ship.paused = true;
				openShop();
			}
		}
	}
	
	function openShop ()
	{
		{
			var i = new Image("graphics/ui.png");
			i.centerOrigin();
			i.x = HXP.halfWidth;
			i.y = HXP.halfHeight;
			var e = scene.addGraphic(i);
			e.followCamera = true;
		}
	}	
	
	var _collideShip : Bool = false;
}
