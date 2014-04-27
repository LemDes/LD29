package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;

class Radar extends Entity
{
	public var radius:Int;
	
	private var background:Image;
	private var gl:Graphiclist = new Graphiclist();
	
	private var radarX:Int=400;
	private var radarY:Int=400;
	
	private var w:Int;
	private var h:Int;
	
	public function new(radius:Int, width:Int, height:Int, ?x:Int=0, ?y:Int=0)
	{
		super(x,y);
		this.radius = radius;
		
		w = width;
		h = width;
		background = new Image(HXP.createBitmap(w,h));
			
		graphic = gl;
		setHitbox(2*radius,2*radius, radarX-radius,radarY-radius);
		type = "radar";
	}
	
	override public function update()
	{
		gl.removeAll();
		var treasureList = new Array<Treasure>();
		collideTypesInto(["treasure"], radarX-radius, radarY-radius, treasureList);
		
		gl.add(background);
		for (treasure in treasureList)
		{
			var relativeX = Std.int(w*(treasure.x - radarX + radius)/(radius)) ;
			var relativeY = Std.int(h*(treasure.y - radarY + radius)/(radius)) ;
			var dot = new Image(HXP.createBitmap(5,5,0xff0000));
			dot.x = relativeX - 2;
			dot.y = relativeY - 2;
			gl.add(dot);			
		}
	}
		
	public function setPosition(x:Int, y:Int)
	{
		this.radarX = x;
		this.radarY = y;
	}
		
		
}