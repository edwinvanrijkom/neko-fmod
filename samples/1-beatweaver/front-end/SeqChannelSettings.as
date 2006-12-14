package {

import swhx.Api;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;

public class SeqChannelSettings extends MovieClip {
	public var txtSample: TextField;
	public var btnOpen: MovieClip;
	
	private var _channel: int;
	
	function SeqChannelSettings() {
		super();
		addEventListener('mouseDown', onPress );
		txtSample.text = "<Sample path will be read from Back-end>";
	}
		
	function set channel(v: int) {
		_channel = v;
		txtSample.text = swhx.Api.call("sequencer.getSoundPath",v);
	}	
		
	public function onPress(e: MouseEvent) {
		if (e.target == btnOpen) {
			txtSample.text = swhx.Api.call("sequencer.setSoundPath",_channel);
		}
	}
}

} // package