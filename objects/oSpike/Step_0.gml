/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

if (global.pause) return;

switch (state) {
	case SpikeState.idle: {
		vSpeed += grav;
		if (place_meeting(x, y + vSpeed, pGround) || place_meeting(x, y + vSpeed, oCloud) || place_meeting(x, y + 4 * sign(vSpeed), pGround) || place_meeting(x, y + 4 * sign(vSpeed), pGround)) {
			while (!place_meeting(x, y + 4 * sign(vSpeed), pGround) && !place_meeting(x, y + 4 * sign(vSpeed), oCloud)) {
				y += sign(vSpeed);
			}
			vSpeed = 0;
		}
		y += vSpeed;
		break;
	}
	case SpikeState.grabbed: {
		hSpeed = 0;
		vSpeed = 0;
		image_angle = point_direction(oPlayer.x, oPlayer.y, x, y);
		if (place_meeting(x, y, oPlayer)) {
			state = SpikeState.mouth;
			oPlayer.inMouth = self;
		}
		break;
	}
	case SpikeState.mouth: {
		vSpeed = 0;
		var dir = oPlayer.imgXScale;
		x = oPlayer.x + dir - (dir == 1);
		y = oPlayer.y;
		image_angle = (dir == 1) ? 0 : 180;
		break;
	}
	case SpikeState.flying: {
		if (!killsThrower && !place_meeting(x, y, oPlayer)) {
			killsThrower = true;
		}
		flyingCounter += global.timeScale;
		if (flyingCounter > 60 && generator != noone) {
			generator.instance = noone;
			generator = noone;
		}
			
		vSpeed += grav;
		image_angle = point_direction(0, 0, hSpeed, vSpeed);
		
		var scaledHSpeed = hSpeed * global.timeScale;
		var scaledVSpeed = vSpeed * global.timeScale;
		
		if (collision_line(x, y, x + scaledHSpeed, y + scaledVSpeed, pGround, true, true) != noone || collision_line(x, y, x + scaledHSpeed, y + scaledVSpeed, oPoison, true, true) != noone || collision_line(x, y, x + scaledHSpeed, y + scaledVSpeed, oCloud, true, true) != noone || (scaledVSpeed > 0 && collision_line(x, y, x + scaledHSpeed, y + scaledVSpeed, oOneWayWall, true, true) != noone)) {
			while (!place_meeting(x, y, pGround) && place_meeting(x, y, oPoison)) {
				x += lengthdir_x(1, image_angle);
				y += lengthdir_y(1, image_angle);
			}
			x += lengthdir_x(5, image_angle);
			y += lengthdir_y(5, image_angle);
		}
		else {
			x += scaledHSpeed;
			y += scaledVSpeed;
		}
		
		if (place_meeting(x, y, pGround) || place_meeting(x, y, oPoison) || place_meeting(x, y, oCloud)) || (vSpeed > 0 &&  place_meeting(x, y, oOneWayWall)) {
			getStuck();
		}
		if (y > room_height) {
			instance_destroy();
		}
		break;
	}
	case SpikeState.stuck: {
		break;
	}
	case SpikeState.discarded: {
		image_xscale -= 0.02;
		image_yscale -= 0.02;
		image_alpha -= 0.04;
		if (image_alpha <= 0) {
			instance_destroy();
		}
		vSpeed += grav;
		x += hSpeed;
		y += vSpeed
		break;
	}
}
