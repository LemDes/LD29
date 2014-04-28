package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;

class Radar extends Entity
{
	public var radius:Int;
	
	public function new(radius:Int, ?x:Int=0, ?y:Int=0)
	{
		super(x,y);
		this.radius = radius;
		setHitbox(2*radius,2*radius,Std.int(x-3*radius), Std.int(y-3*radius));
		type = "radar";
	}
		
	public function setPosition(x:Int, y:Int)
	{
		this.x = x;
		this.y = y;
	}
		
		
}