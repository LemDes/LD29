package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.masks.Circle;

class Radar extends Entity
{
	private var _radius:Int;
	public var radius(get, set):Int;
	private inline function get_radius():Int {return _radius;}
	
	private function set_radius(value:Int):Int
	{
		_radius = value;
		// mask = new Circle(_radius, -1*Std.int(x-3*_radius), -1*Std.int(y-3*_radius));
		cast(mask, Circle).radius = _radius;
		return _radius;
	}
	
	public function new(radius:Int, ?x:Int=0, ?y:Int=0)
	{
		super(x,y);
		this._radius = radius;
		mask = new Circle(_radius, -1*Std.int(x-3*_radius), -1*Std.int(y-3*_radius));
		type = "radar";
	}
		
	public function setPosition(x:Int, y:Int)
	{
		this.x = x;
		this.y = y;
	}		
}
