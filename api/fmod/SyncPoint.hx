package fmod;

class SyncPoint {
	
	var _sound: Void;
	public var _syncpoint(default,null): Void;
	
	public function new(_s: Void, _sp: Void) {
		_sound = _s;
		_syncpoint = _sp;
	}
	
	static var _sp_del = neko.Lib.load("fmod","fmod_sound_delete_sync_point",2);
	public function delete() {
		return _sp_del(_sound,_syncpoint);
		_sound = null;
		_syncpoint = null;
	}
}