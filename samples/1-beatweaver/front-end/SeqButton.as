package {

import flash.display.MovieClip;
import flash.events.Event;

public class SeqButton extends MovieClip {
	public var led: SeqButtonLed;
	var _on: Boolean = false;
	var _id: int = -1;
	
	function SeqButton() {
		super();
		addEventListener('mouseDown', onPress );
	}
	
	public function set on(v: Boolean) {
		_on = v;
		led.on = _on;				
	}
	
	public function get on(): Boolean {
		return _on;
	}
	
	public function onPress(e: Event) {
		on = !_on;
		e.relatedObject = this;
	}
	
	public function set id(v: int) {
		_id = v;
	}
	
	public function get id(): int {
		return _id;
	}
}

} // package