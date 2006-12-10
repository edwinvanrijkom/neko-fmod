package {

import swhx.Api;
	
import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.events.Event;
	
public class Beatweaver extends MovieClip {

	public var channel1: SeqButtonBar;
	public var channel2: SeqButtonBar;
	public var channel3: SeqButtonBar;
	public var channel4: SeqButtonBar;
	
	public var btnPlay: SeqButtonLed;
	public var channelSettings: SeqChannelSettings;
	
	var channels: Array;	
	var channel: SeqButtonBar = null;
	
	//var debug: Boolean = true;
	var debug: Boolean = false;
	var dbgdata: Array = [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,];
		
	function Beatweaver() {
		super();
		init();
	}
	
	function init() {
		
		// initialize the Screenweaver AS Api:
		swhx.Api.init(this);
				
		addEventListener(MouseEvent.MOUSE_DOWN, onPress );
		
		channels = [channel1,channel2,channel3,channel4];
		for (i in channels) {	
			channels[i].id = i;			
			channels[i].setData
				( debug 
				// if we're running from the Flash IDE, 
				// use sample data:
				? dbgdata 
				// otherwise, get the grid data from the back-end:
				: swhx.Api.call("sequencer.getGrid",i)
				);
			channels[i].onChange = onChange;
			channels[i].onMute = onMute;
		}
		selectChannel(channel1);
	}
	
	// invoked on a value in the boolean grid changing:
	function onChange(channel: int, note: int, on: Boolean) {
		swhx.Api.call("sequencer.updateGrid",channel,note,on);
	}
	
	// invoked on a channels mute button being pressed:
	function onMute(channel: int, mute: Boolean) {
		swhx.Api.call("sequencer.muteChannel",channel,mute);
	}
		
	// top level press handler:	
	function onPress(e: MouseEvent){
		if (e.relatedObject is SeqButtonBar)
			// A channel was clicked, focus it:
			selectChannel(e.relatedObject as SeqButtonBar);
		else if (e.relatedObject == btnPlay) {
			// The play button was pressed:
			// ask the back-end to toggle play-back:
			swhx.Api.call("sequencer.play");
		}
	}
	
	// bring focus to a channel (useful for adding
	// per channel settings, on expanding the app.)
	function selectChannel(channel: SeqButtonBar) {
		// toggle previously selected channel off:
		if (this.channel != null) this.channel.gotoAndStop(1);
		// toggle selected channel on:
		this.channel = channel;
		this.channel.gotoAndStop(2);
		trace("setting channel: "+channelSettings);
		channelSettings.channel = channel.id;
	}
}

} // eo package