package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.masks.Hitbox;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Harbor extends Entity
{
	var shop = new Array<Entity>();
	
	public function new (x:Float, y:Float, width:Float, height:Float)
	{
		super(x, y);
		
		setHitbox(Std.int(width), Std.int(height));
		type = "harbor";
		
		var t = new Text("Press S to open harbour shop", 0, 0, 0, 0, {color: 0, size: 20});
		t.centerOrigin();
		shopMsg = new Entity();
		shopMsg.graphic = t;
		shopMsg.x = centerX;
		shopMsg.y = centerY + 20;
	}
	
	override public function update ()
	{
		var ship:Ship = cast(scene, scenes.BoatStage).ship;
		var collideShip = collide("ship", x, y) != null;
		
		if (collideShip != _collideShip)
		{
			_collideShip = collideShip;
			
			if (collideShip)
			{
				// add msg
				scene.add(shopMsg);
			}
			else
			{
				// del msg
				scene.remove(shopMsg);
			}
		}
		
		if (collideShip && Input.pressed(Key.S))
		{
			ship.paused = !ship.paused;
			
			if (ship.paused)
				openShop();
			else
				closeShop();
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
		
		var fullPrice = ship.fuelMax - Std.int(ship.fuel / 15);
		
		shop[shop.length] = scene.add(new ui.TextButton(45, 210, "Upgrade to a medium ship\nFuel capacity: 250\nCargo capacity: 30\nPrice: 1,000$", 0xFFFFFF, 0x0000FF, buyMedium, {size: 20}));
		shop[shop.length] = scene.add(new ui.TextButton(45, 320, "Upgrade to a large ship\nFuel capacity: 600\nCargo capacity: 100\nPrice: 20,000$", 0xFFFFFF, 0x0000FF, buyLarge, {size: 20}));
		shop[shop.length] = scene.add(new ui.TextButton(65, 135, 'Sell your cargo content\nValue: ${ship.value()}$$', 0xFFFFFF, 0x0000FF, sell, {size: 20, align: "center"}));
		shop[shop.length] = scene.add(new ui.TextButton(305, 135, "Buy 10 fuel\n10$", 0xFFFFFF, 0x0000FF, buy10, {size: 20, align: "center"}));
		shop[shop.length] = scene.add(new ui.TextButton(445, 135, 'Buy full fuel\n$fullPrice$$', 0xFFFFFF, 0x0000FF, buyFull, {size: 20, align: "center"}));
		shop[shop.length] = scene.add(new ui.TextButton(580, 55, "X", 0xFFFFFF, 0x0000FF, closeShop, {size: 20}));
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
		
		if (ship.value() > 0)
		{
			var s = new Sfx(#if flash "audio/cash.mp3" #else "audio/cash.ogg" #end);
			s.play();
			ship.sell();
		}
		
		updateShop();
	}
	
	function updateShop()
	{
		cast(scene, scenes.BoatStage).ship.updateGUI();
		closeShop();
		openShop();
		scene.updateLists();
	}
	
	function buyFuel ()
	{
		var s = new Sfx(#if flash "audio/fuel.mp3" #else "audio/fuel.ogg" #end);
		s.play();
	}
	
	function buy10 ()
	{
		var ship:Ship = cast(scene, scenes.BoatStage).ship;
		
		if (ship.cash >= 10 && ship.fuel < ship.fuelMax * 15)
		{
			ship.cash -= 10;
			ship.fuel = Std.int(Math.min(ship.fuel + 150, ship.fuelMax * 15));
			buyFuel();
		}
		
		updateShop();
	}
	
	function buyFull ()
	{
		var ship:Ship = cast(scene, scenes.BoatStage).ship;
		var fullPrice = ship.fuelMax - Std.int(ship.fuel / 15);
		
		if (ship.cash >= fullPrice && ship.fuel < ship.fuelMax * 15)
		{
			ship.cash -= fullPrice;
			ship.fuel = 15 * ship.fuelMax;
			buyFuel();
		}
		
		updateShop();
	}
	
	function buyMedium ()
	{
		
	}
	
	function buyLarge ()
	{
		
	}
	
	var _collideShip : Bool = false;
	var shopMsg : Entity;
}
