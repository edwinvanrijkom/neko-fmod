package fmod;

class Channel {
	
	public var _channel(getChannel,null): Void;
	public var playing(getPlaying,null): Bool;
	public var paused(null,setPaused): Bool;
	public var mute(default,setMute): Bool;
	public var volume(null,setVolume): Float;
	public var pan(null,setPan): Float;
	public var priority(null,setPriority): Int;
						
	public function new(channel: Void) {
		_channel = channel;
		mute = false;
	}
	
	function getChannel(): Void {
		return _channel;
	}
	
	static var _set_cb = neko.Lib.load("fmod","fmod_channel_set_sync_cb",2);
	public function setSyncPointCallback(cb: Int->Int->Void) {
		return _set_cb(_channel,cb);
	}
	
	static var _playing = neko.Lib.load("fmod","fmod_channel_is_playing",1);
	function getPlaying(): Bool {
		return _playing(_channel);
	}
	
	static var _set_pos = neko.Lib.load("fmod","fmod_channel_set_position",3);
	public function setPosition(pos: Int, pt: Int) {
		return _set_pos(_channel,pos,pt);
	}
	
	static var _set_paused = neko.Lib.load("fmod","fmod_channel_set_paused",2);
	function setPaused(p: Bool) {
		return _set_paused(_channel,p);
	}
	
	static var _set_mute = neko.Lib.load("fmod","fmod_channel_set_mute",2);
	function setMute(m: Bool) {
		mute = m;
		return _set_mute(_channel,m);
	}
	
	static var _set_prio = neko.Lib.load("fmod","fmod_channel_set_priority",2);
	function setPriority(p: Int) {
		return _set_prio(_channel,p);
	}
	
	static var _set_pan = neko.Lib.load("fmod","fmod_channel_set_pan",2);
	function setPan(p: Float) {
		return _set_pan(_channel,p);
	}
	
	static var _set_volume = neko.Lib.load("fmod","fmod_channel_set_volume",2);
	function setVolume(v: Float) {
		return _set_volume(_channel,v);
	}
	
	static var _set_delay = neko.Lib.load("fmod","fmod_channel_set_delay",3);
	public function setDelay(start: Int, stop: Int) {
		return _set_delay(_channel,start,stop);
	}
}