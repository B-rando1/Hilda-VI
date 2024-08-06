switch (state) {
	case STATE.NORMAL:
	
		hSpeed = walkSpeed * (keyboard_check(ord("D")) - keyboard_check(ord("A")));

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
		
		collision();
		
		whip.step();
		
	break;
	case STATE.GRAPPLE:
	
		grappleLength = min(point_distance(x, y, grappleX, grappleY), whip.length - 1);
		changeGL = false;
		var ang = point_direction(x, y, grappleX, grappleY);
		
		var fallAng = (x > grappleX) ? ang + 90 : ang - 90;
		var fallMag = fallGrav * cos(abs(degtorad(angle_difference(fallAng, 270))));
		if (place_meeting(x, y + 1, oGround) || place_meeting(x + sign(grappleX - x), y, oGround)) {
			fallMag = 0;
		}
		
		if (place_meeting(x, y + 1, oGround)) {
			hSpeed = walkSpeed * (keyboard_check(ord("D")) - keyboard_check(ord("A")));
		}
		else {
			hSpeed += grappleHAccel * (keyboard_check(ord("D")) - keyboard_check(ord("A")));
			if (y > grappleY) {
				hSpeed += fallMag * cos(degtorad(fallAng));
			}
		}
	
		if (y > grappleY) {
			
			if (keyboard_check(ord("S")) || keyboard_check(ord("W"))) {
				grappleLength = min(grappleLength + grappleVSpeed * (keyboard_check(ord("S")) - keyboard_check(ord("W"))), whip.length - 1);
			}
			else if (keyboard_check_released(ord("S")) || keyboard_check_released(ord("W"))) {
				vSpeed = 0;
			}
			
		}
		
		vSpeed -= fallMag * sin(degtorad(fallAng));
		
		if (mouse_check_button_pressed(mb_left)) {
			jump()
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