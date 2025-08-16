audio_stop_sound(bgSound);
audio_stop_sound(enemySound1);
audio_stop_sound(enemySound2);
audio_stop_sound(enemySound3);
global.gain = 1;
audio_master_gain(global.mute ? 0 : 1);