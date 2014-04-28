package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

import com.haxepunk.graphics.atlas.Atlas;
import com.haxepunk.RenderMode;
import flash.display.BitmapData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;

class RadarUI extends Entity
{
	private var background:Image;
	private var boat:Image;
	private var gl:Graphiclist = new Graphiclist();
	
	private var radius:Int;
	
	public function new(radius:Int, x:Int=0, y:Int=0)
	{
		super(x,y);
		
		followCamera = true;
		this.radius = radius;
		
		background = createRadar(radius);	
		
		var type = "small";
		boat = new Image('graphics/ships/ship_${type}_body.png');
		boat.centerOO();
		var scale = 0.5*radius/cast(HXP.scene,scenes.BoatStage).radar.radius;
		boat.scaleX = scale;
		boat.scaleY = scale;
		boat.x = radius;
		boat.y = radius;
		
		graphic = gl;
	}
	
	static function createRadar (radius:Int)
	{
		HXP.sprite.graphics.clear();
		HXP.sprite.graphics.beginFill(0x00D400);
		HXP.sprite.graphics.drawCircle(radius, radius, radius);
		HXP.sprite.graphics.beginFill(0x005C01);
		HXP.sprite.graphics.drawCircle(radius, radius, radius-1);
		HXP.sprite.graphics.lineStyle(1, 0x00D400, 1, false, LineScaleMode.NORMAL, null, JointStyle.MITER);
		HXP.sprite.graphics.moveTo(radius, 0);
		HXP.sprite.graphics.lineTo(radius, radius * 2);
		HXP.sprite.graphics.moveTo(0, radius);
		HXP.sprite.graphics.lineTo(radius * 2, radius);
		
		var data:BitmapData = HXP.createBitmap(radius * 2, radius * 2, true, 0);
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
	
	override public function update()
	{
		gl.removeAll();
		
		var treasureList = new Array<Treasure>();
		var radar = cast(HXP.scene, scenes.BoatStage).radar;
		boat.angle = cast(cast(HXP.scene, scenes.BoatStage).ship.graphic, Image).angle;
		radar.collideTypesInto(["treasure"], radar.x, radar.y, treasureList);
		gl.add(background);
		gl.add(boat);
		
		for (treasure in treasureList)
		{
			var scale = radius/radar.radius;
			var relativeX = Std.int((treasure.x - radar.x + radar.radius) * scale) ;
			var relativeY = Std.int((treasure.y - radar.y + radar.radius) * scale) ;
			var dot = Image.createCircle(2, 0x00FF00);
			dot.x = relativeX - 2;
			dot.y = relativeY - 2;
			// trace(dot.x + " " + dot.y);
			gl.add(dot);			
		}
	}
}
