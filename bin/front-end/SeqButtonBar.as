package {

import flash.display.MovieClip;
import flash.events.MouseEvent;

import flash.filters.GlowFilter;
import flash.filters.BitmapFilter;
import flash.filters.BitmapFilterQuality;

public class SeqButtonBar extends MovieClip {
		
	public var b1,b2,b3,b4: SeqButton;	
	public var b5,b6,b7,b8: SeqButton;
	public var b9,b10,b11,b12: SeqButton;
	public var b13,b14,b15,b16: SeqButton;
	
	public var btnMute: SeqButtonLed;

	private var _buttons: Array;
	private var _id: int;
	private var _onChange: Function;
	private var _onMute: Function;
	private var _focus: int = -1;
	
	function SeqButtonBar() {
		super();
		addEventListener('mouseDown', onPress );	
	}
	
	function get buttons(): Array {
		if (_buttons == null) {
			_buttons = new Array
				( b1,b2,b3,b4
				, b5,b6,b7,b8
				, b9,b10,b11,b12
				, b13,b14,b15,b16
				);			
			var i: int = 0;
			for (;i<16;i++) buttons[i].id = i;
		}
		return _buttons;
	}
	
	function setData(data: Array) {
		var i: int = 16;
		while(i--) buttons[i].on = data[i];
	}
	
	function getData(): Array {
		var result = new Array();
		for (var i: int = 0; i<16; i++) {
			result.push(buttons[i].on);
		}
		return result;
	}
	
	function set onChange(v: Function) {
		_onChange = v;
	}
	
	function set onMute(v: Function) {
		_onMute = v;
	}
	
	function onPress(e: MouseEvent) {
		if (e.target is SeqButton) {
			var btn: SeqButton = e.target as SeqButton;
			if (_onChange != null) {
				_onChange(_id,btn.id,btn.on);
			}
		}
		if (e.relatedObject == btnMute) {
			if (_onMute != null) {
				_onMute(_id,btnMute.on);
			}
		}
		e.relatedObject = this;
	}
	
	public function set id(v: int) {
		_id = v;
	}
	
	public function get id(): int {
		return _id;
	}
	
	public function set focus(id: int) {
		trace("focus "+id);
		if (_focus != -1)
			buttons[_focus].filters = [];
		_focus = id;
		if (_focus != -1)
			buttons[_focus].filters = [new GlowFilter(0xFF0000,0.8,15,15,5,BitmapFilterQuality.HIGH,false,false)];
	}
	
	public function get focus(): int {
		return _focus;
	}
}

} // package