package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.masks.Polygon;

import com.haxepunk.graphics.atlas.Atlas;
import com.haxepunk.RenderMode;
import flash.display.BitmapData;

class HomeBeaconArrow extends Entity
{
	var arrow : Image;
	var radius = 90;
	
	public function new ()
	{
		super();
		
		arrow = createArrow(20);
		arrow.centerOrigin();
		arrow.smooth = true;
		graphic = arrow;
		layer = -10;
	}
	
	static function createArrow (radius:Int)
	{
		HXP.sprite.graphics.clear();
		HXP.sprite.graphics.beginFill(0);
		HXP.sprite.graphics.moveTo(0, 0);
		HXP.sprite.graphics.lineTo(radius, 0);
		HXP.sprite.graphics.lineTo(radius/2, radius);
		HXP.sprite.graphics.lineTo(0, 0);
		HXP.sprite.graphics.endFill();
		
		var data:BitmapData = HXP.createBitmap(radius, radius, true, 0);
		data.draw(HXP.sprite);

		var image:Image;
		if (HXP.renderMode == RenderMode.HARDWARE)
		{
			image = new Image(Atlas.loadImageAsRegion(data));
		}
		else
		{
			image = new Image(data);
		}

		return image;
	}
	
	override public function update ()
	{
		var ship = cast(scene, scenes.BoatStage).ship;
		var harbor = cast(scene, scenes.BoatStage).harbor;
		var phi = HXP.angle(ship.centerX, ship.centerY, harbor.centerX, harbor.centerY);
		arrow.angle = phi + 90;
		phi *= HXP.RAD;
		
		x = ship.centerX + radius * Math.cos(phi);
		y = ship.centerY + radius * Math.sin(phi);
	}
} 
