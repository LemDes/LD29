package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

class RadarUI extends Entity
{
	private var background:Image;
	private var gl:Graphiclist = new Graphiclist();
	
	private var w:Int;
	private var h:Int;
	
	// private var origX:Int;
	// private var origY:Int;
	
	public function new(width:Int, height:Int,?x:Int,?y:Int)
	{
		super(x,y);
		w = width;
		h = width;
		
		// origX = x;
		// origY = y;
		
		followCamera = true;
		background = Image.createRect(w,h,0);			
		graphic = gl;
	}
	
	override public function update()
	{
		gl.removeAll();
		var treasureList = new Array<Treasure>();
		var radar = cast(HXP.scene, scenes.BoatStage).radar;
		radar.collideTypesInto(["treasure"],radar.x,radar.y, treasureList);
		gl.add(background);
		for (treasure in treasureList)
		{
			var relativeX = Std.int(w*(treasure.x - radar.x + radar.radius)/(2*radar.radius)) ;
			var relativeY = Std.int(h*(treasure.y - radar.y + radar.radius)/(2*radar.radius)) ;
			var dot = Image.createCircle(2,0xff0000);
			dot.x = relativeX - 2;
			dot.y = relativeY - 2;
			gl.add(dot);			
		}
		
		// x = HXP.camera.x + origX;
		// y = HXP.camera.y + origY;
	}
}