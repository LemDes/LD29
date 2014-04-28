package ui;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;

import haxe.Timer;

class Message extends Entity
{
	private static var currentMessage:Message;
	private var timeStamp:Float;
	private var duration:Float;
	
	public function new(message:String, ?x:Float=0, ?y:Float=0, ?duration=5)
	{
		super(x,y);
		timeStamp = Timer.stamp();
		this.duration = duration;
		graphic = new Text(message);
	}
	
	override public function added()
	{
		if (currentMessage != null)
		{
			HXP.scene.remove(currentMessage);
		}
		currentMessage = this;
	}
	
	override public function update()
	{
		super.update();
		if (Timer.stamp() - timeStamp >= duration)
		{
			HXP.scene.remove(this);
		}
		
	}
}