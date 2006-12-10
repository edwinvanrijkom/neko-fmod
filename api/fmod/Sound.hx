package fmod;

class Sound {
	
	public var _sound(default,null): Void;
	public var loops(null,setLoopCount): Int;
		
	public function new(sound: Void) {
		_sound = sound;
	}
	
	static var _add_sp = neko.Lib.load("fmod","fmod_sound_add_sync_point",4);
	public function addSyncPoint(offset: Int, type: Int, name: String) {
		return new SyncPoint(_sound,_add_sp(_sound,offset,type,untyped name.__s));
	}
	
	static var _set_lc = neko.Lib.load("fmod","fmod_sound_set_loop_count",2);
	function setLoopCount(count: Int) {
		_set_lc(_sound,count);
		return count;
	}
	
	static var _set_lp = neko.Lib.load("fmod","fmod_sound_set_loop_points",5);
	public function setLoopPoints(start: Int, st: Int, end: Int, et: Int) {
		return _set_lp(_sound,start,st,end,et);
	} 
	
	static var _set_subsound = neko.Lib.load("fmod","fmod_sound_set_sub_sound",3);
	public function setSubSound(i: Int, s: Sound) {
		return _set_subsound(_sound,i,s._sound);
	}
}