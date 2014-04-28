package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.masks.Polygon;

class HomeBeaconDistance extends Entity
{
	var distance : Text;
	var radius = 70;
	
	public function new ()
	{
		super();
		
		graphic = distance = new Text("0m", {color: 0, font: "font/LinLibertine_R.ttf"});
	}
	
	override public function update ()
	{
		var ship = cast(scene, scenes.BoatStage).ship;
		var harbor = cast(scene, scenes.BoatStage).harbor;
		var phi = HXP.angle(ship.centerX, ship.centerY, harbor.centerX, harbor.centerY);
		
		var d = Std.int(HXP.distanceRectPoint(ship.x, ship.y, harbor.x, harbor.y, harbor.width, harbor.height));
		distance.text = '${d}m';
		distance.centerOrigin();
		
		distance.angle = phi + 90;
		phi *= HXP.RAD;
		
		x = ship.centerX + radius * Math.cos(phi);
		y = ship.centerY + radius * Math.sin(phi);
	}
} 
