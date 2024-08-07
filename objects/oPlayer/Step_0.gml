if (place_meeting(x, y + 1, oGround)) {
	postCoyTime = postCoyTimeMax;
	if (mouse_check_button_pressed(mb_left) || preCoyTime > 0) {
		jump();
	}
}
else {
	if (!mouse_check_button(mb_left) || vSpeed > 0) {
		jumpUp = false;
	}
	if (!jumpUp && mouse_check_button_pressed(mb_left)) {
		if (postCoyTime > 0) {
			jump();
		}
		else {
			preCoyTime = preCoyTimeMax;
		}
	}
	vSpeed += jumpUp ? grav : fallGrav;
}

preCoyTime = max(preCoyTime - 1, 0);
postCoyTime = max(postCoyTime - 1, 0);

switch (state) {
	case STATE.NORMAL:
	
		hSpeed = walkSpeed * (keyboard_check(ord("D")) - keyboard_check(ord("A")));
		
		collision();
		
		whip.step();
		
	break;
	case STATE.GRAPPLE:
	
		grappleLength = min(point_distance(x, y, grappleX, grappleY), whip.length);
		changeGL = false;
		var ang = point_direction(x, y, grappleX, grappleY);
		
		var fallAng = (x > grappleX) ? ang + 90 : ang - 90;
		var fallMag = fallGrav * cos(abs(degtorad(angle_difference(fallAng, 270))));
		
		if (place_meeting(x, y + 1, oGround)) {
			hSpeed = walkSpeed * (keyboard_check(ord("D")) - keyboard_check(ord("A")));
		}
		else {
			hSpeed += grappleHAccel * (keyboard_check(ord("D")) - keyboard_check(ord("A")));
			if (y > grappleY && !place_meeting(x, y + 1, oGround)) {
				hSpeed += fallMag * cos(degtorad(fallAng));
			}
		}
	
		if (y >= grappleY) {
			
			if (keyboard_check(ord("S")) || keyboard_check(ord("W"))) {
				var newGrappleLength = min(grappleLength + grappleVSpeed * (keyboard_check(ord("S")) - keyboard_check(ord("W"))), whip.length);
				var lenDelta = grappleLength - newGrappleLength
				grappleLength = newGrappleLength;
				if (lenDelta < 0) {
					hSpeed += lengthdir_x(lenDelta, ang);
					vSpeed += lengthdir_y(lenDelta, ang);
				}
			}
			else if (keyboard_check_released(ord("S")) || keyboard_check_released(ord("W"))) {
				vSpeed = 0;
			}
			
		}
		
		vSpeed -= fallMag * sin(degtorad(fallAng));
		
		if (preCoyTime > 0 && y >= grappleY) {
			jump();
			collision();
			state = STATE.NORMAL
			whip.step();
		}
		else {
			collisionGrapple();
			whip.grapple();
		}
		
	break;
	default:
		throw("Something went horribly wrong");
}