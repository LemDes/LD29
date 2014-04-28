package ui;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;

class TextButton extends Entity
{	
	var color : Int;
	var hoverColor : Int;
	var cb : Void->Void;
	
	public function new (x:Int, y:Int, text:String, color:Int, hoverColor:Int, cb:Void->Void, options:TextOptions)
	{
		super(x, y);
		
		graphic = new Text(text, 0, 0, 0, 0, options);
		this.color = cast(graphic, Text).color = color;
		this.hoverColor = hoverColor;
		this.cb = cb;
		followCamera = true;
	}
	
	override public function update ()
	{
		followCamera = false;
		
		var t : Text = cast graphic;
		
		if (HXP.distanceRectPoint(Input.mouseFlashX, Input.mouseFlashY, x, y, t.width, t.height) == 0) // mouse on text
		{
			t.color = hoverColor;
			
			if (Input.mouseReleased)
			{
				// link clicked
				if (cb != null)
				{
					cb();
				}
			}
		}
		else
		{
			t.color = color;
		}
		
		followCamera = true;
	}
}
