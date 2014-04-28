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
		
		shop[shop.length] = scene.add(new ui.TextButton(45, 210, "Upgrade to a medium ship\nFuel capacity: 250\nCargo capacity: 30\nPrice: 1,000$", 0xFFFFFF, 0x0000FF, buyMedium, {size: 20}));
		shop[shop.length] = scene.add(new ui.TextButton(45, 320, "Upgrade to a large ship\nFuel capacity: 600\nCargo capacity: 100\nPrice: 20,000$", 0xFFFFFF, 0x0000FF, buyLarge, {size: 20}));
		shop[shop.length] = scene.add(new ui.TextButton(45, 145, 'Sell your cargo for ${ship.value()}$$', 0xFFFFFF, 0x0000FF, sell, {size: 20}));
		shop[shop.length] = scene.add(new ui.TextButton(305, 135, "Buy 10 fuel\nX$", 0xFFFFFF, 0x0000FF, buy10, {size: 20}));
		shop[shop.length] = scene.add(new ui.TextButton(445, 135, "Buy full fuel\nY$", 0xFFFFFF, 0x0000FF, buyFull, {size: 20}));
		shop[shop.length] = scene.add(new ui.TextButton(470, 70, "Close the shop", 0xFFFFFF, 0x0000FF, closeShop, {size: 20}));
	}
	
	function closeShop ()
	{
		for (e in shop)
		{
			scene.remove(e);
		}
		
		cast(scene, scenes.BoatStage).ship.paused = false;
	}
	
	function sell ()
	{
		var ship:Ship = cast(scene, scenes.BoatStage).ship;	
		ship.sell();
		ship.updateGUI();
		closeShop();
		openShop();
		scene.updateLists();
	}
	
	function buy10 ()
	{
		
	}
	
	function buyFull ()
	{
		
	}
	
	function buyMedium ()
	{
		
	}
	
	function buyLarge ()
	{
		
	}
	
	var _collideShip : Bool = false;
}
