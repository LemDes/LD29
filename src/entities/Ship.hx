package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
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
	static inline var SPEED_X:Int = 3;
	static inline var SPEED_Y:Int = 5;
	
	public var capacity:Int = 0;
	public var maxCapacity(default,null):Int;
	
	var treasureList:Array<Treasure> = new Array<Treasure>();
	
	public var cash:Int;
	
	public var fuel:Int;
	public var fuelMax:Int;
	var alive:Bool = true;
	var victory:Bool = false;
	
	
	var time : Float = 0;
	var score : Int = 0;
	
	public var boatType:String;
	
	public var paused : Bool = false;
		
	override public function new (type:String, fuelMax:Int, maxCapacity:Int, x:Float, y:Float,?cash:Int=0)
	{
		super(x, y);
		
		boatType = type;
		fuel = this.fuelMax = fuelMax;
		this.maxCapacity = maxCapacity;
		
		this.cash = cash;
		
		fuel *= 15;
		
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
		if (paused)
		{
			return;
		}
		
		if (fuel > 0)
		{
			time += HXP.elapsed;
			
			var dx:Int = 0;
			var dy:Int = 0;
			
			if (Input.check("up")) { dy += SPEED_Y; }
			if (Input.check("down")) { dy -= SPEED_Y; }
			if (Input.check("left")) { dx += SPEED_X; }
			if (Input.check("right")) { dx -= SPEED_X; }
			if (Input.pressed(Key.E))
			{
				var e = collide("treasure",x,y);
				if (e != null)
				{
					var treasure = cast(e,Treasure);
					if(capacity + treasure.weight <= maxCapacity)
					{
						capacity += treasure.weight;
						treasureList.push(treasure);
						scene.remove(treasure);
						cast(scene, scenes.BoatStage).treasureNumber --;
						if (cast(scene, scenes.BoatStage).treasureNumber == 0)
						{
							victory = true;
							gameOver();
						}
						HXP.scene.add(new ui.Message("You picked a " + treasure.descr + ".",4));
					}
					else
					{
						HXP.scene.add(new ui.Message("This treasure weights too much", 4));
					}
				}
			}
			
			var ok = true;
			var da = HXP.sign(dx) * 3;
			
			if (dx != 0)
			{
				cast(mask, Polygon).angle += dx;
				cast(graphic, Image).angle += dx;
				
				if (collide("solid", x, y) != null)
				{
					cast(mask, Polygon).angle -= dx;
					cast(graphic, Image).angle -= dx;
				}
			}
			
			var ox = x;
			var oy = y;
			
			if (dy != 0)
			{				
				var a = (cast(graphic, Image).angle + 90) * HXP.RAD;
				
				x += Math.cos(a) * dy;
				y += Math.sin(a) * dy;
				
				if (collide("solid", x, y) != null)
				{
					x = ox;
					y = oy;
				}
			}
			
			fuel -= Std.int(HXP.distance(x, y, ox, oy));
			
			// updateGUI();
			
			cast(HXP.scene,scenes.BoatStage).radar.moveAtAngle(cast(graphic, Image).angle + 90, dy, "");
			
			scene.camera.x = x - HXP.screen.width/2 - cast(graphic, Image).width/2;
			scene.camera.y = y - HXP.screen.height/2 - cast(graphic, Image).height/2;
			
			cast(HXP.scene,scenes.BoatStage).radar.setPosition(Std.int(x+(cast(graphic, Image).x)),Std.int(y+(cast(graphic, Image).y)));
		}
		else if (alive)
		{
			alive = false;
			
			var s = new Sfx(#if flash "audio/boom.mp3" #else "audio/boom.ogg" #end);
			s.play(HXP.volume);
			
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
			e.layer = -20;
		}
		
		{
			var t = new Text((victory) ? "You won" : "Game Over!", 0, 0, 0, 0, {color: 0xFFFFFF, size: 50});
			t.centerOrigin();
			t.x = HXP.halfWidth;
			t.y = 100;
			var e = scene.addGraphic(t);
			e.followCamera = true;
			e.layer = -20;
		}
		{
			if (victory)
			{
				var t = new Text("Write a fruit name in your comment", 0, 0, 0, 0, {color: 0xFFFFFF, size: 20});
				t.centerOrigin();
				t.x = HXP.halfWidth;
				t.y = 150;
				var e = scene.addGraphic(t);
				e.followCamera = true;
			}
		}
		
		{
			var t = new Text('Final score: $score\nSurvived for: ${Std.int(time)}s', 0, 0, 0, 0, {color: 0xFFFFFF, size: 30});
			t.x = 100;
			t.y = 200;
			var e = scene.addGraphic(t);
			e.followCamera = true;
			e.layer = -20;
		}
		
		{
			var t = new Text("Thanks for playing.\n\nMade by ibilon and elnabo\nfor LD29.", 0, 0, 0, 0, {color: 0xFFFFFF, size: 20, align: "center"});
			t.centerOrigin();
			t.x = HXP.halfWidth;
			t.y = HXP.height - 100;
			var e = scene.addGraphic(t);
			e.followCamera = true;
			e.layer = -20;
		}
	}
	
	public function sell()
	{
		var v = value();
		cash += v;
		score += v;
		
		treasureList = new Array<Treasure>();
		capacity = 0;
	}
	
	public function value ()
	{
		var c = 0;
		
		for (treasure in treasureList)
		{
			c += treasure.price;
		}
		
		return c;
	}
	
	// public function updateGUI ()
	// {
		// fuelGUI.text = 'Fuel: ${Std.int(fuel / 15)} / $fuelMax';			
		// capacityGUI.text = 'Cargo: ${capacity} / $maxCapacity';
		// cashGUI.text = 'Money: ${cash}$$';
	// }
	
	// override public function removed()
	// {
		// for (e in guiEntities)
		// {
			// HXP.scene.remove(e);
		// }
	// }
} 
