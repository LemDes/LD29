package scenes;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Text;

import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;

class BoatStage extends Scene
{
	var map : TmxMap;
	
	public var ship : entities.Ship;
	public var radar : entities.Radar;
	public var radarUI : entities.RadarUI;
	public var harbor : entities.Harbor;
	
	private var minItem:Int = 2;
	private var maxTry:Int = 5;
	private var proba:Float = 1.0 ;
	
	public var boatStartX:Float;
	public var boatStartY:Float;
	
	public var treasureNumber:Int = 0;
	
	var fuelGUI:Text;
	var capacityGUI:Text;
	var cashGUI:Text;
	var treasureGUI:Text;
	
	override public function begin ()
	{	
		map = TmxMap.loadFromFile("maps/75.tmx");
		
		// create the map
		var e = new TmxEntity(map);

		// load layers named bottom, main, top with the appropriate tileset
		e.loadGraphic("graphics/overland_preview.png", ["layer1"]);

		// loads a grid layer named collision and sets the entity type to walls
		e.loadMask("collision", "solid");

		add(e);
		
		for(object in map.getObjectGroup("objects").objects)
		{
			if (object.type == "harbor")
			{
				add(harbor = new entities.Harbor(object.x, object.y, object.width, object.height));
			}
			
			if (object.type == "ship")
			{
				boatStartX = object.x;
				boatStartY = object.y;
				// add(ship = new entities.Ship("small", 100, 10, object.x, object.y));
				add(ship = new entities.Ship("small", 100, 10, object.x, object.y));
			}
		}
		
		
		addProgressbars();
		
		updateLists();
		
		for (i in 1...15)
		{
			for (j in 1...15)
			{
				var collider = new entities.Treasure(0, 0);		
				var c = 0;
				var tryC = 0;
				
				while (c < minItem && tryC < maxTry)
				{
					tryC += 1;
					
					var x = (Std.random(5) + i*5) * map.tileWidth;
					var y = (Std.random(5) + j*5) * map.tileHeight;
					
					if (collider.collideTypes(["solid", "harbor"], x, y, true) == null)
					{
						var t = new entities.Treasure(x, y);
						treasureNumber += 1;
						add(t);
						c += 1;
					}
				}
			}
		}
		
		add(radar = new entities.Radar(100, 400, 400));
		add(radarUI = new entities.RadarUI(40, HXP.screen.width - 100, HXP.screen.height - 100));
		add(new entities.HomeBeaconArrow());
		add(new entities.HomeBeaconDistance());
		add(new ui.Mute(HXP.width - 30,10));
	}
	
	override public function update ()
	{
		super.update();
		
		camera.x = Math.max(0, Math.min(map.fullWidth - HXP.screen.width, camera.x));
		camera.y = Math.max(0, Math.min(map.fullHeight - HXP.screen.height, camera.y));
		
		updateGUI();
	}
	
	function addProgressbars()
	{
		var dx : Float = 0;
		
		{
			fuelGUI = new Text('Fuel: ${Std.int(ship.fuel / 15)} / $ship.fuelMax', 0, 0, 0, 0, {color: 0, size: 20});
			var e = addGraphic(fuelGUI);
			e.followCamera = true;
			e.x = 10;
			e.y = 10;
			dx = e.x + fuelGUI.width/2;
			// trace(fuelGUI.width);
			// trace(e.width);
		}
		
		{
			capacityGUI = new Text('Cargo: ${ship.capacity} / $ship.maxCapacity', 0, 0, 0, 0, {color: 0, size: 20});
			var e = addGraphic(capacityGUI);
			e.followCamera = true;
			e.y = 10;
			e.x = dx + 30;
			dx = e.x + capacityGUI.width/2;
			// trace(capacityGUI.width);
		}
		
		{
			cashGUI = new Text('Money: ${ship.cash}$$', 0, 0, 0, 0, {color: 0, size: 20});
			var e = addGraphic(cashGUI);
			e.followCamera = true;
			e.y = 10;
			e.x = dx;
			dx = e.x + cashGUI.width;
			// trace(e.x);
		}
		{
			treasureGUI = new Text('Treasure: ${treasureNumber}', 0, 0, 0, 0, {color: 0, size: 20});
			var e = addGraphic(treasureGUI);
			e.followCamera = true;
			e.y = 10;
			e.x = dx + 30;
			// trace(e.x);
		}
	}
	
	public function updateGUI ()
	{
		fuelGUI.text = 'Fuel: ${Std.int(ship.fuel / 15)} / ${ship.fuelMax}';			
		capacityGUI.text = 'Cargo: ${ship.capacity} / ${ship.maxCapacity}';
		cashGUI.text = 'Money: ${ship.cash}$$';
		treasureGUI.text = 'Treasure: ${treasureNumber}';
	}
}
