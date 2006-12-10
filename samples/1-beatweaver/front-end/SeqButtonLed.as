package {

import flash.display.MovieClip;
import flash.events.MouseEvent;

public class SeqButtonLed extends MovieClip{
	
	var _on: Boolean;
	
	function SeqButtonLed() {
		super();
		addEventListener('mouseDown', onPress );
	}
	
	public function set on(v: Boolean) {
		if (v)
			gotoAndStop(2);
		else
			gotoAndStop(1);
		_on = v;	
	}
	
	public function get on(): Boolean {
		return _on;
	}
	
	function onPress(e: MouseEvent) {
		on = !_on;
		e.relatedObject = this;
	}
}
	
} // package
