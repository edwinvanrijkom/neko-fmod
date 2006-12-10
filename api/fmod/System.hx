package fmod;

class System {
	
	public static var FMOD_TIMEUNIT_MS                = 0x00000001; /* Milliseconds. */
	public static var FMOD_TIMEUNIT_PCM               = 0x00000002; /* PCM Samples, related to milliseconds * samplerate / 1000. */
	public static var FMOD_TIMEUNIT_PCMBYTES          = 0x00000004; /* Bytes, related to PCM samples * channels * datawidth (ie 16bit = 2 bytes). */
	public static var FMOD_TIMEUNIT_RAWBYTES          = 0x00000008; /* Raw file bytes of (compressed) sound data (does not include headers).  Only used by Sound::getLength and Channel::getPosition. */
	public static var FMOD_TIMEUNIT_MODORDER          = 0x00000100; /* MOD/S3M/XM/IT.  Order in a sequenced module format.  Use Sound::getFormat to determine the PCM format being decoded to. */
	public static var FMOD_TIMEUNIT_MODROW            = 0x00000200; /* MOD/S3M/XM/IT.  Current row in a sequenced module format.  Sound::getLength will return the number of rows in the currently playing or seeked to pattern. */
	public static var FMOD_TIMEUNIT_MODPATTERN        = 0x00000400; /* MOD/S3M/XM/IT.  Current pattern in a sequenced module format.  Sound::getLength will return the number of patterns in the song and Channel::getPosition will return the currently playing pattern. */
	public static var FMOD_TIMEUNIT_SENTENCE_MS       = 0x00010000; /* Currently playing subsound in a sentence time in milliseconds. */
	public static var FMOD_TIMEUNIT_SENTENCE_PCM      = 0x00020000; /* Currently playing subsound in a sentence time in PCM Samples, related to milliseconds * samplerate / 1000. */
	public static var FMOD_TIMEUNIT_SENTENCE_PCMBYTES = 0x00040000; /* Currently playing subsound in a sentence time in bytes, related to PCM samples * channels * datawidth (ie 16bit = 2 bytes). */
	public static var FMOD_TIMEUNIT_SENTENCE          = 0x00080000; /* Currently playing sentence index according to the channel. */
	public static var FMOD_TIMEUNIT_SENTENCE_SUBSOUND = 0x00100000; /* Currently playing subsound index in a sentence. */
	public static var FMOD_TIMEUNIT_BUFFERED          = 0x10000000; /* Time value as seen by buffered stream.  This is always ahead of audible time, and is only used for processing. */
	
	public static var FMOD_DEFAULT                   = 0x00000000; /* FMOD_DEFAULT is a default sound type.  Equivalent to all the defaults listed below.  FMOD_LOOP_OFF, FMOD_2D, FMOD_HARDWARE. */
	public static var FMOD_LOOP_OFF                  = 0x00000001; /* For non looping sounds. (DEFAULT).  Overrides FMOD_LOOP_NORMAL / FMOD_LOOP_BIDI. */
	public static var FMOD_LOOP_NORMAL               = 0x00000002; /* For forward looping sounds. */
	public static var FMOD_LOOP_BIDI                 = 0x00000004; /* For bidirectional looping sounds. (only works on software mixed static sounds). */
	public static var FMOD_2D                        = 0x00000008; /* Ignores any 3d processing. (DEFAULT). */
	public static var FMOD_3D                        = 0x00000010; /* Makes the sound positionable in 3D.  Overrides FMOD_2D. */
	public static var FMOD_HARDWARE                  = 0x00000020; /* Attempts to make sounds use hardware acceleration. (DEFAULT). */
	public static var FMOD_SOFTWARE                  = 0x00000040; /* Makes the sound be mixed by the FMOD CPU based software mixer.  Overrides FMOD_HARDWARE.  Use this for FFT, DSP, compressed sample support, 2D multi-speaker support and other software related features. */
	public static var FMOD_CREATESTREAM              = 0x00000080; /* Decompress at runtime, streaming from the source provided (ie from disk).  Overrides FMOD_CREATESAMPLE and FMOD_CREATECOMPRESSEDSAMPLE.  Note a stream can only be played once at a time due to a stream only having 1 stream buffer and file handle.  Open multiple streams to have them play concurrently. */
	public static var FMOD_CREATESAMPLE              = 0x00000100; /* Decompress at loadtime, decompressing or decoding whole file into memory as the target sample format (ie PCM).  Fastest for playback and most flexible.  */
	public static var FMOD_CREATECOMPRESSEDSAMPLE    = 0x00000200; /* Load MP2, MP3, IMAADPCM or XMA into memory and leave it compressed.  During playback the FMOD software mixer will decode it in realtime as a 'compressed sample'.  Can only be used in combination with FMOD_SOFTWARE.  Overrides FMOD_CREATESAMPLE.  If the sound data is not ADPCM, MPEG or XMA it will behave as if it was created with FMOD_CREATESAMPLE and decode the sound into PCM. */
	public static var FMOD_OPENUSER                  = 0x00000400; /* Opens a user created static sample or stream. Use FMOD_CREATESOUNDEXINFO to specify format and/or read callbacks.  If a user created 'sample' is created with no read callback, the sample will be empty.  Use Sound::lock and Sound::unlock to place sound data into the sound if this is the case. */
	public static var FMOD_OPENMEMORY                = 0x00000800; /* "name_or_data" will be interpreted as a pointer to memory instead of filename for creating sounds.  Use FMOD_CREATESOUNDEXINFO to specify length.  FMOD duplicates the memory into its own buffers.  Can be freed after open. */
	public static var FMOD_OPENMEMORY_POINT          = 0x10000000; /* "name_or_data" will be interpreted as a pointer to memory instead of filename for creating sounds.  Use FMOD_CREATESOUNDEXINFO to specify length.  This differs to FMOD_OPENMEMORY in that it uses the memory as is, without duplicating the memory into its own buffers.  FMOD_SOFTWARE only.  Doesn't work with FMOD_HARDWARE, as sound hardware cannot access main ram on a lot of platforms.  Cannot be freed after open, only after Sound::release.   Will not work if the data is compressed and FMOD_CREATECOMPRESSEDSAMPLE is not used. */
	public static var FMOD_OPENRAW                   = 0x00001000; /* Will ignore file format and treat as raw pcm.  Use FMOD_CREATESOUNDEXINFO to specify format.  Requires at least defaultfrequency, numchannels and format to be specified before it will open.  Must be little endian data. */
	public static var FMOD_OPENONLY                  = 0x00002000; /* Just open the file, dont prebuffer or read.  Good for fast opens for info, or when sound::readData is to be used. */
	public static var FMOD_ACCURATETIME              = 0x00004000; /* For System::createSound - for accurate Sound::getLength/Channel::setPosition on VBR MP3, and MOD/S3M/XM/IT/MIDI files.  Scans file first, so takes longer to open. FMOD_OPENONLY does not affect this. */
	public static var FMOD_MPEGSEARCH                = 0x00008000; /* For corrupted / bad MP3 files.  This will search all the way through the file until it hits a valid MPEG header.  Normally only searches for 4k. */
	public static var FMOD_NONBLOCKING               = 0x00010000; /* For opening sounds asyncronously.  Use Sound::getOpenState to poll the state of the sound as it opens in the background. */
	public static var FMOD_UNIQUE                    = 0x00020000; /* Unique sound, can only be played one at a time */
	public static var FMOD_3D_HEADRELATIVE           = 0x00040000; /* Make the sound's position, velocity and orientation relative to the listener. */
	public static var FMOD_3D_WORLDRELATIVE          = 0x00080000; /* Make the sound's position, velocity and orientation absolute (relative to the world). (DEFAULT) */
	public static var FMOD_3D_LOGROLLOFF             = 0x00100000; /* This sound will follow the standard logarithmic rolloff model where mindistance = full volume, maxdistance = where sound stops attenuating, and rolloff is fixed according to the global rolloff factor.  (DEFAULT) */
	public static var FMOD_3D_LINEARROLLOFF          = 0x00200000; /* This sound will follow a linear rolloff model where mindistance = full volume, maxdistance = silence.  Rolloffscale is ignored. */
	public static var FMOD_3D_CUSTOMROLLOFF          = 0x04000000; /* This sound will follow a rolloff model defined by Sound::set3DCustomRolloff / Channel::set3DCustomRolloff.  */
	public static var FMOD_CDDA_FORCEASPI            = 0x00400000; /* For CDDA sounds only - use ASPI instead of NTSCSI to access the specified CD/DVD device. */
	public static var FMOD_CDDA_JITTERCORRECT        = 0x00800000; /* For CDDA sounds only - perform jitter correction. Jitter correction helps produce a more accurate CDDA stream at the cost of more CPU time. */
	public static var FMOD_UNICODE                   = 0x01000000; /* Filename is double-byte unicode. */
	public static var FMOD_IGNORETAGS                = 0x02000000; /* Skips id3v2/asf/etc tag checks when opening a sound, to reduce seek/read overhead when opening files (helps with CD performance). */
	public static var FMOD_LOWMEM                    = 0x08000000; /* Removes some features from samples to give a lower memory overhead, like Sound::getName.  See remarks. */
	public static var FMOD_LOADSECONDARYRAM          = 0x20000000; /* Load sound into the secondary RAM of supported platform.  On PS3, sounds will be loaded into RSX/VRAM. */
		
	var _system: Void;
	
	public var version(getVersion,null): Int;
	
	static var _create = neko.Lib.load("fmod", "fmod_system_create", 0);
	public function new() {
		_system = _create();
	}
	
	static var _update = neko.Lib.load("fmod", "fmod_system_update", 1);
	public function update() {
		return _update(_system);
	}
	
	static var _getVersion = neko.Lib.load("fmod", "fmod_system_get_version",1);
	function getVersion(): Int {
		return _getVersion(_system);
	}
	
	static var _init = neko.Lib.load("fmod", "fmod_system_init",3);
	public function init(maxChannels: Int) {
		return _init(_system,maxChannels,0);
	}
	
	static var _createSound = neko.Lib.load("fmod", "fmod_system_create_sound",3);
	public function createSound(path: String, ?flags: Int): Sound {
		if (flags == null) flags = FMOD_SOFTWARE;
		var sound = _createSound(_system, untyped path.__s, flags);
		return if (sound != null)
				new Sound(sound);
			else
			 	null;
	}
	
	static var _createSoundSub = neko.Lib.load("fmod", "fmod_system_create_sound_sub",4);
	public function createSoundSub(path: String, flags: Int,sub: Int): Sound {
		if (flags == null) flags = FMOD_SOFTWARE;
		var sound = _createSoundSub(_system, untyped path.__s, flags, sub);
		return if (sound != null)
				new Sound(sound);
			else
			 	null;
	}

	static var _playSound = neko.Lib.load("fmod", "fmod_system_play_sound",4);
	public function playSound(snd: Sound, channel: Int, play: Bool) {
		var channel = _playSound(_system,snd._sound,channel,play);
		return if (channel != null)
				new Channel(channel);
			else
			 	null;
	}
}