package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.masks.Polygon;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;

import flash.geom.Point;

class Ship extends Entity
{
	static inline var SPEED:Int = 3;
	
	public var capacity:Int = 0;
	var maxCapacity:Int = 10;
	var treasureList:Array<Treasure> = new Array<Treasure>();
	public var cash:Int = 0;
		
	override public function new (type:String)
	{
		super(400, 400);
		
		var boat = new Image('graphics/ships/ship_${type}_body.png');
		boat.centerOO();
		boat.smooth = true;
		
		graphic = boat;
		
		setHitbox(boat.width, boat.height, boat.width, boat.height);
		
		mask = Polygon.createFromArray([-boat.width, -boat.height, -boat.width, 0, 0, 0, 0, -boat.height]);
		cast(mask, Polygon).origin = new Point(-boat.width/2, -boat.height/2);
	
		this.type = "ship";
	}
	
	override public function update ()
	{
		var dx:Int = 0;
		var dy:Int = 0;
		
		if (Input.check("up")) { dy += SPEED; }
		if (Input.check("down")) { dy -= SPEED; }
		if (Input.check("left")) { dx += SPEED; }
		if (Input.check("right")) { dx -= SPEED; }
		if (Input.check(Key.E))
		{
			var e = collide("treasure",x,y);
			if (e != null)
			{
				var treasure = cast(e,Treasure);
				trace(capacity+" "+treasure.weight);
				if(capacity + treasure.weight < maxCapacity)
				{
					capacity += treasure.weight;
					treasureList.push(treasure);
					scene.remove(treasure);
				}
			}
		}
		
		var ok = true;
		var da = HXP.sign(dx);
		for (i in 1...Std.int(Math.abs(dx)))
		{
			if (ok)
			{
				cast(mask, Polygon).angle += da;
				cast(graphic, Image).angle += da;
			}
			
			if (collide("solid", x, y) != null)
			{
				cast(mask, Polygon).angle -= da;
				cast(graphic, Image).angle -= da;
				ok = false;
			}
		}		
		
		moveAtAngle(cast(graphic, Image).angle + 90, dy, "solid");
		cast(HXP.scene,scenes.BoatStage).radar.moveAtAngle(cast(graphic, Image).angle + 90, dy, "");
		
		scene.camera.x = x - HXP.screen.width/2 - cast(graphic, Image).width/2;
		scene.camera.y = y - HXP.screen.height/2 - cast(graphic, Image).height/2;
		
		cast(HXP.scene,scenes.BoatStage).radar.setPosition(Std.int(x+(cast(graphic, Image).x)),Std.int(y+(cast(graphic, Image).y)));
	}
	
	public function sell()
	{
		for (treasure in treasureList)
		{	
			treasureList.remove(treasure);
			cash += treasure.price;
		}
		trace(cash);
		capacity = 0;
	}
} 
