/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

audio_stop_sound(bgSound);
audio_stop_sound(enemySound1);
audio_stop_sound(enemySound2);
audio_stop_sound(enemySound3);
global.gain = 1;
audio_master_gain(global.mute ? 0 : 1);