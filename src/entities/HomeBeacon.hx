package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.masks.Polygon;

class HomeBeacon extends Entity
{
	var arrow : Image;
	var distance : Text;
	var radius = 20;
	
	public function new ()
	{
		super();
		
		arrow = Image.createPolygon(Polygon.createPolygon(3, 15));
		arrow.centerOrigin();
		distance = new Text("0m");
		graphic = new Graphiclist([arrow, distance]);
	}
	
	override public function update ()
	{
		var ship = cast(scene, scenes.BoatStage).ship;
		var harbor = cast(scene, scenes.BoatStage).harbor;
		var phi = HXP.angle(ship.x, ship.y, harbor.x + harbor.width/2, harbor.y + harbor.height/2) + 60;
		arrow.angle = phi;
		phi *= HXP.RAD;
		
		x = ship.x + radius * Math.cos(phi);
		y = ship.y + radius * Math.sin(phi);
		
		var d = Std.int(HXP.distance(ship.x, ship.y, harbor.x + harbor.width/2, harbor.y + harbor.height/2));
		distance.text = '${d}m';
	}
} 
