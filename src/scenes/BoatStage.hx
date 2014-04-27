package scenes;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Backdrop;

import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;

class BoatStage extends Scene
{
	var map : TmxMap;
	
	public var ship : entities.Ship;
	public var radar : entities.Radar;
	public var harbor : entities.Harbor;
	
	private var minItem:Int = 10;
	private var maxTry:Int = 20;
	private var proba:Float = 1.0 ;
	
	override public function begin ()
	{	
		map = TmxMap.loadFromFile("maps/test.tmx");
		
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
				harbor = new entities.Harbor(object.x, object.y, object.width, object.height);
				add(harbor);
			}
		}
		
		updateLists();
		
		var collider = new entities.Treasure(0, 0);
		var treasures = new Array<entities.Treasure>();
		
		while ( minItem > treasures.length)
		{
			var x = Std.random(map.width) * map.tileWidth;
			var y = Std.random(map.height) * map.tileHeight;
			
			if (collider.collideTypes(["solid", "harbor"], x, y, true) == null)
			{
				var t = new entities.Treasure(x, y);
				treasures.push(t);
				add(t);
			}
		}
		
		add(ship = new entities.Ship("small"));
		add(radar = new entities.Radar(100,60,60,500,500));
	}
	
	override public function update ()
	{
		super.update();
		
		camera.x = Math.max(0, Math.min(map.fullWidth - HXP.screen.width, camera.x));
		camera.y = Math.max(0, Math.min(map.fullHeight - HXP.screen.height, camera.y));
	}
}
