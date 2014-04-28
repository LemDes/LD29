package ui;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;

class Mute extends Entity
{	
	var on : Image = new Image('graphics/mute.png');
	var off : Image = new Image('graphics/muted.png');
	var muted : Bool = false;
	
	public function new (x:Int, y:Int)
	{
		super(x, y);
		
		graphic = on;
		followCamera = true;
		layer = -20;
	}
	
	override public function update ()
	{
		followCamera = false;
		
		var t:Image = cast graphic;
		
		if (HXP.distanceRectPoint(Input.mouseFlashX, Input.mouseFlashY, x, y, t.width, t.height) == 0) // mouse on text
		{			
			if (Input.mouseReleased)
			{
				muted = !muted;
				if (!muted)
				{
					graphic = on;
					HXP.volume = 1;
				}
				else
				{
					graphic = off;
					HXP.volume = 0;
				}
			}
		}
		
		followCamera = true;
	}
}
