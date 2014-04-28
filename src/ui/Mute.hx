package ui;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Mute extends Entity
{	
	var on : Image = new Image('graphics/mute.png');
	var off : Image = new Image('graphics/muted.png');
	var muted : Bool = false;
	
	var s:Sfx;
	
	public function new (x:Int, y:Int)
	{
		super(x, y);
		
		graphic = on;
		followCamera = true;
		layer = -20;
		
		s = new Sfx(#if flash "audio/music.mp3" #else "audio/music.ogg" #end);
		s.loop(0.5);
	}
	
	override public function update ()
	{
		followCamera = false;
		
		var t:Image = cast graphic;
		
		if ((HXP.distanceRectPoint(Input.mouseFlashX, Input.mouseFlashY, x, y, t.width, t.height) == 0 && Input.mouseReleased) || Input.pressed(Key.M))
		{
			muted = !muted;
			if (!muted)
			{
				graphic = on;
				HXP.volume = 1;
				s.resume();
			}
			else
			{
				graphic = off;
				HXP.volume = 0;
				s.stop();
			}
		}
		
		followCamera = true;
	}
}
