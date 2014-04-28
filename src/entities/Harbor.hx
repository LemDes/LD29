package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.masks.Hitbox;

class Harbor extends Entity
{
	var shop = new Array<Entity>();
	
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
				//ship.sell();
				ship.paused = true;
				openShop();
			}
		}
	}
	
	function openShop ()
	{
		var ship:Ship = cast(scene, scenes.BoatStage).ship;
		
		{
			var i = new Image("graphics/ui_shop.png");
			i.centerOrigin();
			i.x = HXP.halfWidth;
			i.y = HXP.halfHeight;
			var e = scene.addGraphic(i);
			e.followCamera = true;
			shop[shop.length] = e;
		}
		
		{
			var t = new Text("Upgrade to a medium ship\nFuel capacity: 250\nCargo capacity: 30\nPrice: 1,000$", {color: 0xFFFFFF, size: 20});
			t.x = 45;
			t.y = 210;
			var e = scene.addGraphic(t);
			e.followCamera = true;
			shop[shop.length] = e;
		}
		
		{
			var t = new Text("Upgrade to a large ship\nFuel capacity: 600\nCargo capacity: 100\nPrice: 20,000$", {color: 0xFFFFFF, size: 20});
			t.x = 45;
			t.y = 320;
			var e = scene.addGraphic(t);
			e.followCamera = true;
			shop[shop.length] = e;
		}
		
		{
			var t = new Text('Sell your cargo for ${ship.value()}$$', {color: 0xFFFFFF, size: 20});
			t.x = 45;
			t.y = 145;
			var e = scene.addGraphic(t);
			e.followCamera = true;
			shop[shop.length] = e;
		}
	}
	
	function closeShop ()
	{
		for (e in shop)
		{
			scene.remove(e);
		}
		
		cast(scene, scenes.BoatStage).ship.paused = false;
	}
	
	var _collideShip : Bool = false;
}
