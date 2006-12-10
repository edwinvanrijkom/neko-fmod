import fmod.Sound;
import fmod.Channel;

import systools.Dialogs;

class Beatweaver {

	// Library objects;
	static var flash: swhx.Flash;
	static var cnx: swhx.Connection;
	static var fsys: fmod.System;
		
	// Grid storing 16th notes state, per channel:
	static var grid =
		[	[1,0,0,1, 0,1,0,0, 1,0,1,0, 0,0,0,1]
		,	[0,0,0,0, 1,0,0,1, 0,0,0,0, 1,0,0,0]
		,	[0,0,0,0, 1,0,0,0, 0,1,0,0, 0,1,0,0]
		,	[0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,1]
		];
	
	static var connected: Bool = false;	
	static var seqthread;	
	static var playing = false;
	static var interval: Float;
	static var tick_count = 16;
	static var channel_count = 4;
	static var tick: Int = -1;
	
	// FMOD specific:		
	static var sounds: Array<Sound> = 
		[null,null,null,null];
	static var channels: Array<Channel> = 
		[null,null,null,null];
	static var muted = 
		[false,false,false,false];
	static var soundpaths: Array<String> = 
		[ "samples/70s/bass_muted.aif"
		, "samples/70s/snare_muted.aif"
		, "samples/70s/hihat_bark.aif"
		, "samples/70s/hihat_open.aif"
		];
	static var soundflags
		= fmod.System.FMOD_SOFTWARE
		| fmod.System.FMOD_CREATESAMPLE
		| fmod.System.FMOD_LOWMEM;
		
	// guide sound: (silent)
	static var guide;
	static var guide_channel;	
	// sync points:
	static var sps = 
		[ null,null,null,null
		, null,null,null,null
		, null,null,null,null
		, null,null,null,null
		];
	
	
	
	// Application entry point:			
	static function main() {		
			
		seqthread = neko.vm.Thread.create(sequencerLoop);
		
		// Initialize the Screenweaver HX module.
		// require the Flash 9 player to be present:
		swhx.Application.init(9);
		
		// Appliction window width and height:
		var width = 500;
		var height = 420;

		// Set up a neko remoting server.
		// We will use the server to invoke calls
		// on the GUI
		var server = new neko.net.RemotingServer();
		server.addObject("sequencer",Beatweaver);

		// Instruct the Screenweaver module to create a new
		// application window, titled "Beatweaver"
		var wnd = new swhx.Window("Beatweaver",width,height);
		wnd.resizable = true;
		wnd.show(true);
		
		// Instruct the Screenweaver module to host a
		// Flash movie (our GUI) in the Window:
		flash = new swhx.Flash(wnd,server);
		flash.setAttribute("id","ui");
		flash.setAttribute("src","ui.swf");
		flash.onSourceLoaded = onSourceLoaded;
		flash.start();
				
		// Instruct the Screenweaver module to start
		// the application loop. It will listen to OS events,
		// and forward them to our Window, and Flash:
		swhx.Application.loop();
		
		// Ending up here means that our window has been 
		// closed. Instruct Screenweaver to clean-up.
		swhx.Application.cleanup();			
	}
	
	static function sequencerLoop() {
		trace("entering loop");	
		
		fsys = new fmod.System();
		trace(fsys);
		fsys.init(25);
		
		setBPM(110);

		for (i in 0...channel_count) {		
			sounds[i] = fsys.createSound(soundpaths[i], soundflags);
		}			
							
		while(true) {
			try {
				fsys.update();				
				neko.Sys.sleep(0.001);
			}
			catch(e: Dynamic)
			{
				trace("exception: "+e);
			}					
		}		
	}
	
	static function on16thTick(i1: Int, i2: Int): Void {
		for (i in 0...channel_count) {								
			if (sounds[i] != null && grid[i][i1] !=0) {	
				if (!(channels[i] != null && (channels[i].mute))) {
					channels[i]=fsys.playSound(sounds[i],i,false);	
				}								
			}										
		}
		tick = i1;
	}
	
	static function getTickIndex(): Int {
		return tick;
	}	
	
	static function onSourceLoaded() {		
		trace("Main Flash content loading complete.");		
		cnx = swhx.Connection.flashConnect(flash);
		connected = true;
	}	
		
	static function setBPM(bpm: Int) {
		trace("setBPM: "+bpm);		
		interval = 15000/bpm; 
		
		if (guide==null) {
			guide = fsys.createSound("samples/silence.wav", fmod.System.FMOD_LOOP_NORMAL | fmod.System.FMOD_SOFTWARE | fmod.System.FMOD_CREATESAMPLE );
			guide.loops = -1;
		}
		
		trace("guide track length: "+(tick_count*interval)+" msec");
		var lpr = guide.setLoopPoints
			( 0, fmod.System.FMOD_TIMEUNIT_MS
			, Math.round(tick_count*interval)-1
			, fmod.System.FMOD_TIMEUNIT_MS
			);
		trace("setLoopPoints: "+lpr);	
		
		for (i in 0...tick_count) {
			if (sps[i]!=null) sps[i].delete();
			var offset = 1+i*Math.round(interval);
			trace("syncpoint "+i+" offset: "+offset);
			sps[i] = guide.addSyncPoint
				( offset
				, fmod.System.FMOD_TIMEUNIT_MS
				, "tick_countthNote-"+(i)
				);
		};
		
		if (guide_channel==null) {
			trace("guide channel: "+(guide_channel = fsys.playSound(guide,24,true)) );				
			trace("guide syncpoint cb: "+guide_channel.setSyncPointCallback(on16thTick) );	
		}		
	}
	
	static function updateGrid(channel: Int, note: Int, on: Bool) {
		trace("updateGrid: "+channel+" note: "+note+" on: "+on);
		grid[channel][note]=if (on==true) 1 else 0;
		return 0;
	}
	
	static function getGrid(channel: Int) {
		trace("getGrid: "+channel);
		return grid[channel];
	}
		
	static function play() {
		trace("play: "+!playing);
		guide_channel.paused = playing;
		playing = !playing;
		if (!playing) tick = -1;
		return 0;		
	}
	
	static function muteChannel(channel: Int, mute: Bool) {
		trace("mute: "+channel+" ("+mute+")");
		channels[channel].mute = mute;
		trace(channels[channel].mute);
		return 0;
	}
	
	static function getSoundPath(channel: Int) {
		trace("getSoundPath "+channel);
		return soundpaths[channel];
	}
	
	static function setSoundPath(channel: Int) {
		trace("setSoundPath"+channel);
		var filters: FILEFILTERS = 
			{ count: 2
			, descriptions: ["WAV files", "AIF files"]
			, extensions: ["*.wav","*.aif"]			
			};		
		var result = Dialogs.openFile
			( "Select a new sample for channel "+channel
			, "Sound files can be either in wave or aif format."
			, filters 
			);
		if (result != null) {
			soundpaths[channel]=result[0];
			sounds[channel] = fsys.createSound(soundpaths[channel], soundflags);
		}
		return soundpaths[channel];
	}
}
