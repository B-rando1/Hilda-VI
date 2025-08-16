/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

hSpeed = 0;
vSpeed = 0;
launchSpeed = 25;
grav = 0.2;
depth += 10;

flyingCounter = 0;
killsThrower = false;

launch = function(_angle) {
	hSpeed = lengthdir_x(launchSpeed, _angle);
	vSpeed = lengthdir_y(launchSpeed, _angle);
	state = SpikeState.flying;
	killsThrower = false;
}

getStuck = function() {
	if (place_meeting(x, y, oOrb)) {
		instance_destroy();
	}
	
	audio_play_sound(sndSpike_land, 9, false, 6);
	state = SpikeState.stuck;
	if (generator != noone) {
		generator.instance = noone;
	}
}

beDiscarded = function() {
	state = SpikeState.discarded;
	hSpeed = oPlayer.hSpeed - 4 * oPlayer.imgXScale;
	vSpeed = oPlayer.vSpeed + 5;
}

