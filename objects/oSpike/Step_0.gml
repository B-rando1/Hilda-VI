switch (state) {
	case SpikeState.idle: {
		break;
	}
	case SpikeState.grabbed: {
		image_angle = point_direction(oPlayer.x, oPlayer.y, x, y);
		if (place_meeting(x, y, oPlayer)) {
			state = SpikeState.mouth;
			oPlayer.inMouth = self;
		}
		break;
	}
	case SpikeState.mouth: {
		var dir = oPlayer.image_xscale;
		x = oPlayer.x + 12 * dir - 2 * (dir == 1)
		y = oPlayer.y;
		image_angle = (dir == 1) ? 0 : 180;
		break;
	}
	case SpikeState.flying: {
		if (!killsThrower && !place_meeting(x, y, oPlayer)) {
			killsThrower = true;
		}
		
		vSpeed += grav;
		image_angle = point_direction(0, 0, hSpeed, vSpeed);
		
		if (collision_line(x, y, x + hSpeed, y + vSpeed, pGround, true, true)) || collision_line(x, y, x + hSpeed, y + vSpeed, oDeath, true, true) {
			while (!place_meeting(x, y, pGround) && place_meeting(x, y, oDeath)) {
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
		
		if (place_meeting(x, y, pGround) || place_meeting(x, y, oDeath)) {
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
}
