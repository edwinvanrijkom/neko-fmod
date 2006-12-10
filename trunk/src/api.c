#include <stdio.h>
#include <string.h>

#include <neko/neko.h>
#include <fmod.h>

DEFINE_KIND(k_fmod_system)
DEFINE_KIND(k_fmod_sound)
DEFINE_KIND(k_fmod_channel)
DEFINE_KIND(k_fmod_syncpoint)

void finalize_system(value s){
	if (val_kind(s)==k_fmod_system) {
		FMOD_System_Close(val_data(s));
	}
}

value fmod_system_create() {
	FMOD_SYSTEM *s;
	value r = val_null;
	if (FMOD_System_Create(&s) == FMOD_OK) {
		r = alloc_abstract(k_fmod_system,s);
		val_gc(r,finalize_system);		
	}
	return r;
}
DEFINE_PRIM(fmod_system_create,0);

#define GET_SYSTEM			FMOD_SYSTEM *s; val_check_kind(_s,k_fmod_system); s = val_data(_s);
#define GET_SOUND			FMOD_SOUND *snd; val_check_kind(_snd,k_fmod_sound); snd = val_data(_snd);
#define GET_SYSTEM_SOUND	FMOD_SOUND *snd; GET_SYSTEM val_check_kind(_snd,k_fmod_sound); snd = val_data(_snd);
#define GET_CHANNEL			FMOD_CHANNEL *c; val_check_kind(_c,k_fmod_channel); c = val_data(_c);

value fmod_system_update(value _s) {
	GET_SYSTEM
	return alloc_int(FMOD_System_Update(s));
}
DEFINE_PRIM(fmod_system_update,1);

value fmod_system_get_version(value _s) {
	unsigned int v;
	GET_SYSTEM
	return alloc_int(FMOD_System_GetVersion(s,&v));
}
DEFINE_PRIM(fmod_system_get_version,1);

value fmod_system_init(value _s, value _c, value _f) {
	GET_SYSTEM
	val_check(_c,int);
	val_check(_f,int);
	return alloc_int(FMOD_System_Init(s,val_int(_c),val_int(_f),NULL));
}
DEFINE_PRIM(fmod_system_init,3);

value fmod_system_create_sound(value _s, value _p, value _f) {
	value r = val_null;
	FMOD_SOUND *snd;
	GET_SYSTEM
	val_check(_p,string);
	val_check(_f,int);
	if (FMOD_System_CreateSound(s,val_string(_p),val_int(_f),NULL,&snd) == FMOD_OK) {
		r = alloc_abstract(k_fmod_sound,snd);
		// don't garbage collect: managed by FMOD internally.
		//val_gc(r,finalize_system);
	}
	return r;
}
DEFINE_PRIM(fmod_system_create_sound,3);

value fmod_system_create_sound_sub(value _s, value _p, value _f, value _sc) {
	FMOD_CREATESOUNDEXINFO exinfo;
	value r = val_null;
	FMOD_SOUND *snd;
	GET_SYSTEM
	val_check(_p,string);
	val_check(_f,int);
	val_check(_sc,int);
	memset(&exinfo,0,sizeof(exinfo));
	exinfo.cbsize = sizeof(FMOD_CREATESOUNDEXINFO);
	exinfo.numsubsounds = val_int(_sc);	
    //exinfo.defaultfrequency = 44100;   
    //exinfo.numchannels = 1;
    //exinfo.format = FMOD_SOUND_FORMAT_PCM16;
	
	if (FMOD_System_CreateSound(s,val_string(_p),val_int(_f),&exinfo,&snd) == FMOD_OK) {
		r = alloc_abstract(k_fmod_sound,snd);
		// don't garbage collect: managed by FMOD internally.
		//val_gc(r,finalize_system);
	}
	return r;
}
DEFINE_PRIM(fmod_system_create_sound_sub,4);

value fmod_system_create_stream(value _s, value _p, value _m) {
	value r = val_null;
	FMOD_SOUND *snd;
	GET_SYSTEM
	val_check(_p,string);
	val_check(_m,int);
	if (FMOD_System_CreateStream(s,val_string(_p),val_int(_m),0,&snd) == FMOD_OK) {
		r = alloc_abstract(k_fmod_sound,snd);
		// don't garbage collect: managed by FMOD internally.
		//val_gc(r,finalize_system);
	}
	return r;
}
DEFINE_PRIM(fmod_system_create_stream,3);

value fmod_system_play_sound(value _s, value _snd, value _c, value _p) {
	FMOD_CHANNEL *channel;
	value r = val_null;
	GET_SYSTEM_SOUND
	val_check(_c,int);
	val_check(_p,bool);
	if (FMOD_System_PlaySound(s,val_int(_c), snd, val_bool(_p), &channel) == FMOD_OK) {
		r = alloc_abstract(k_fmod_channel, channel);
		// don't garbage collect: managed by FMOD internally.
	}
	return r;
}
DEFINE_PRIM(fmod_system_play_sound,4);

value fmod_sound_add_sync_point(value _snd, value _o, value _ot, value _n) {
	FMOD_SYNCPOINT *sp;
	value r = val_null;
	GET_SOUND
	val_check(_o,int);
	val_check(_ot,int);
	val_check(_n,string);
	if (FMOD_Sound_AddSyncPoint(snd,val_int(_o),val_int(_ot),val_string(_n),&sp) == FMOD_OK) {
		r = alloc_abstract(k_fmod_syncpoint, sp);
		// don't garbage collect: managed by FMOD internally.
	}
	return r;
}
DEFINE_PRIM(fmod_sound_add_sync_point,4);

value fmod_sound_delete_sync_point(value _snd, value _sp) {
	GET_SOUND
	val_check_kind(_sp,k_fmod_syncpoint);
	return alloc_int(FMOD_Sound_DeleteSyncPoint(snd,val_data(_sp)));
}
DEFINE_PRIM(fmod_sound_delete_sync_point,2);

value fmod_sound_set_mode(value _snd, value _m) {
	GET_SOUND
	val_check(_m,int);
	return alloc_int(FMOD_Sound_SetMode(snd,val_int(_m)));
}
DEFINE_PRIM(fmod_sound_set_mode,2);

value fmod_sound_set_loop_count(value _snd, value _c) {
	GET_SOUND
	val_check(_c,int);
	return alloc_int(FMOD_Sound_SetLoopCount(snd,val_int(_c)));
}
DEFINE_PRIM(fmod_sound_set_loop_count,2);

value fmod_sound_set_loop_points(value _snd, value _s, value _st, value _e, value _et) {
	GET_SOUND
	val_check(_s, int);
	val_check(_st, int);
	val_check(_e, int);
	val_check(_et, int);
	return alloc_int(FMOD_Sound_SetLoopPoints(snd,val_int(_s),val_int(_st),val_int(_e),val_int(_et)));
}
DEFINE_PRIM(fmod_sound_set_loop_points,5);

value fmod_sound_set_sub_sound(value _snd, value _i, value _sub) {
	GET_SOUND
	val_check(_i,int);
	val_check_kind(_sub,k_fmod_sound);
	return alloc_int(FMOD_Sound_SetSubSound(snd,val_int(_i),val_data(_sub)));
}
DEFINE_PRIM(fmod_sound_set_sub_sound,3);

FMOD_RESULT F_CALLBACK fmod_channel_cb (FMOD_CHANNEL *channel, FMOD_CHANNEL_CALLBACKTYPE type, int command, unsigned int commanddata1, unsigned int commanddata2) {
	value cb = (value) command;
	val_call2(cb,alloc_int(commanddata1),alloc_int(commanddata2));
	return FMOD_OK;
}

value fmod_channel_set_sync_cb(value _c, value _cb) {
	GET_CHANNEL
	return alloc_int( FMOD_Channel_SetCallback
		( c
		, FMOD_CHANNEL_CALLBACKTYPE_SYNCPOINT
		, fmod_channel_cb
		, (int)_cb
		)
	);	
}
DEFINE_PRIM(fmod_channel_set_sync_cb,2)

value fmod_channel_is_playing(value _c) {
	FMOD_BOOL playing;
	GET_CHANNEL
	FMOD_Channel_IsPlaying(c,&playing);
	return alloc_bool( playing == 1 ? 1 : 0);
}
DEFINE_PRIM(fmod_channel_is_playing,1);

value fmod_channel_set_position(value _c, value _p, value _pt) {
	GET_CHANNEL	
	val_check(_p,int);
	val_check(_pt,int);
	return alloc_int(FMOD_Channel_SetPosition(c,val_int(_p),val_int(_pt)));
}
DEFINE_PRIM(fmod_channel_set_position,3);

value fmod_channel_set_volume(value _c, value _v) {
	GET_CHANNEL
	val_check(_v,float)
	return alloc_int(FMOD_Channel_SetVolume(c,val_float(_v)));
}	
DEFINE_PRIM(fmod_channel_set_volume,2)

value fmod_channel_set_pan(value _c, value _p) {
	GET_CHANNEL
	val_check(_p,float)
	return alloc_int(FMOD_Channel_SetPan(c,val_float(_p)));
}
DEFINE_PRIM(fmod_channel_set_pan,2)

value fmod_channel_set_priority(value _c,value _p) {
	GET_CHANNEL
	val_check(_p,int)
	return alloc_int(FMOD_Channel_SetPriority(c,val_int(_p)));
}
DEFINE_PRIM(fmod_channel_set_priority,2)

value fmod_channel_set_mute(value _c, value _m) {
	GET_CHANNEL
	val_check(_m,bool)
	return alloc_int(FMOD_Channel_SetMute(c,val_bool(_m)));
}
DEFINE_PRIM(fmod_channel_set_mute,2)

value fmod_set_reverb_props(value _c) {
	FMOD_REVERB_CHANNELPROPERTIES rp;
	GET_CHANNEL
	
	return alloc_int(FMOD_Channel_SetReverbProperties(c,&rp));
}
DEFINE_PRIM(fmod_set_reverb_props,3);

value fmod_channel_set_paused(value _c, value _p) {
	GET_CHANNEL
	val_check(_p,bool)
	return alloc_int(FMOD_Channel_SetPaused(c,val_bool(_p)));
}
DEFINE_PRIM(fmod_channel_set_paused,2);

value fmod_channel_set_delay(value _c, value _sd, value _ed) {
	GET_CHANNEL
	val_check(_sd,int);
	val_check(_ed,int);
	return alloc_int(FMOD_Channel_SetDelay(c,val_int(_sd),val_int(_ed)));
}
DEFINE_PRIM(fmod_channel_set_delay,3);