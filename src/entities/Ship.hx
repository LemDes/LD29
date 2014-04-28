package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
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
	
	public var fuel(default, null):Int;
	var fuelMax:Int;
	var fuelGUI:Text;
	var alive:Bool = true;
	
	var time : Float = 0;
	var score : Int = 0;
		
	override public function new (type:String, fuelMax:Int)
	{
		super(400, 400);
		
		fuel = this.fuelMax = fuelMax;
		fuel *= 15;
		fuelGUI = new Text('Fuel: ${Std.int(fuel / 15)} / $fuelMax', {color: 0, size: 20});
		var e = HXP.scene.addGraphic(fuelGUI);
		e.followCamera = true;
		e.x = e.y = 30;
		
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
		if (fuel > 0)
		{
			time += HXP.elapsed;
			
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
			
			var ox = x;
			var oy = y;
			moveAtAngle(cast(graphic, Image).angle + 90, dy, "solid");
			fuel -= Std.int(HXP.distance(x, y, ox, oy));
			fuelGUI.text = 'Fuel: ${Std.int(fuel / 15)} / $fuelMax';
			
			cast(HXP.scene,scenes.BoatStage).radar.moveAtAngle(cast(graphic, Image).angle + 90, dy, "");
			
			scene.camera.x = x - HXP.screen.width/2 - cast(graphic, Image).width/2;
			scene.camera.y = y - HXP.screen.height/2 - cast(graphic, Image).height/2;
			
			cast(HXP.scene,scenes.BoatStage).radar.setPosition(Std.int(x+(cast(graphic, Image).x)),Std.int(y+(cast(graphic, Image).y)));
		}
		else if (alive)
		{
			alive = false;
			
			var t = new Text("Game Over!", {color: 0, size: 50});
			t.centerOrigin();
			var te = scene.addGraphic(t);
			te.x = centerX;
			te.y = centerY - height;
			
			var expl = new Spritemap("graphics/exp2_0.png", 64, 64, gameOver);
			expl.add("boom", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 15, 15, 15, 15], 10, false);
			expl.play("boom");
			
			var e = scene.addGraphic(expl);
			e.x = centerX - 32;
			e.y = centerY - 32;
		}
	}
	
	function gameOver ()
	{
		{
			var i = new Image("graphics/ui.png");
			i.centerOrigin();
			i.x = HXP.halfWidth;
			i.y = HXP.halfHeight;
			var e = scene.addGraphic(i);
			e.followCamera = true;
		}
		
		{
			var t = new Text("Game Over!", {color: 0xFFFFFF, size: 50});
			t.centerOrigin();
			t.x = HXP.halfWidth;
			t.y = 100;
			var e = scene.addGraphic(t);
			e.followCamera = true;
		}
		
		{
			var t = new Text('Final score: $score\nSurvived for: ${Std.int(time)}s', {color: 0xFFFFFF, size: 30});
			t.x = 100;
			t.y = 200;
			var e = scene.addGraphic(t);
			e.followCamera = true;
		}
		
		{
			var t = new Text("Thanks for playing.\n\nMade by ibilon and elnabo\nfor LD29.", {color: 0xFFFFFF, size: 20, align: "center"});
			t.centerOrigin();
			t.x = HXP.halfWidth;
			t.y = HXP.height - 100;
			var e = scene.addGraphic(t);
			e.followCamera = true;
		}
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
