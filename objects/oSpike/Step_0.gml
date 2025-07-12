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
		x = oPlayer.x + dir - (dir == 1)
		y = oPlayer.y;
		image_angle = (dir == 1) ? 0 : 180;
		break;
	}
	case SpikeState.flying: {
		if (!killsThrower && !place_meeting(x, y, oPlayer)) {
			killsThrower = true;
		}
		flyingCounter ++;
		if (flyingCounter > 60) {
			instance_destroy();
		}
		
		vSpeed += grav;
		image_angle = point_direction(0, 0, hSpeed, vSpeed);
		
		if (collision_line(x, y, x + hSpeed, y + vSpeed, pGround, true, true) != noone || collision_line(x, y, x + hSpeed, y + vSpeed, oPoison, true, true) != noone || collision_line(x, y, x + hSpeed, y + vSpeed, oCloud, true, true) != noone || (vSpeed > 0 && collision_line(x, y, x + hSpeed, y + vSpeed, oOneWayWall, true, true) != noone)) {
			while (!place_meeting(x, y, pGround) && place_meeting(x, y, oPoison)) {
				x += lengthdir_x(1, image_angle);
				y += lengthdir_y(1, image_angle);
			}
			x += lengthdir_x(5, image_angle);
			y += lengthdir_y(5, image_angle);
		}
		else {
			x += hSpeed;
			y += vSpeed;
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
		vspeed += grav;
		break;
	}
}
