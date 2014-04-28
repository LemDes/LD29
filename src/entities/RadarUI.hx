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
	private var gl:Graphiclist = new Graphiclist();
	
	private var radius:Int;
	
	public function new(radius:Int, x:Int=0, y:Int=0)
	{
		super(x,y);
		
		followCamera = true;
		this.radius = radius;
		
		background = createRadar(radius);	
		
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
		radar.collideTypesInto(["treasure"], radar.x, radar.y, treasureList);
		gl.add(background);
		
		for (treasure in treasureList)
		{
			var relativeX = Std.int(radius*(treasure.x - radar.x + radar.radius)/(2*radar.radius)) ;
			var relativeY = Std.int(radius*(treasure.y - radar.y + radar.radius)/(2*radar.radius)) ;
			var dot = Image.createCircle(2, 0x00FF00);
			dot.x = relativeX - 2 + radius/2;
			dot.y = relativeY - 2 + radius/2;
			gl.add(dot);			
		}
	}
}
