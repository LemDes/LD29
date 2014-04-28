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
	
	public function new(message:String, ?duration=5)
	{
		super();
		
		timeStamp = Timer.stamp();
		this.duration = duration;
		graphic = new Text();
		cast(graphic, Text).addStyle("b", {color: 0xFFEF00, bold: true, size: 20});
		cast(graphic, Text).richText = "<b>" + message + "</b>";
		cast(graphic, Text).centerOrigin();
		layer = -10;
	}
	
	override public function added()
	{
		var ship = cast(scene, scenes.BoatStage).ship;
		x = ship.centerX;
		y = ship.centerY;
	
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
