import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.debug.Console;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;

class Main extends Engine
{
	override public function init ()
	{
		#if debug HXP.console.enable(TraceCapture.Yes, Key.A); #end
		HXP.defaultFont = "font/LinLibertine_R.ttf";
		HXP.scene = new scenes.BoatStage();
		HXP.screen.smoothing = true;
		
		Input.define("left", [Key.LEFT]);
		Input.define("right", [Key.RIGHT]);
		Input.define("up", [Key.UP]);
		Input.define("down", [Key.DOWN]);
	}
	
	public static function reset()
	{
		HXP.scene = new scenes.BoatStage();
	}

	public static function main ()
	{
		new Main();
	}
}
