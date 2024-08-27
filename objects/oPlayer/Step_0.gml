if (place_meeting(x, y + 1, oGround)) {
	postCoyTime = postCoyTimeMax;
	if (JUMP_PRESSED || preCoyTime > 0) {
		jump();
	}
}
else {
	if (!JUMP_DOWN || vSpeed > 0) {
		jumpUp = false;
	}
	if (!jumpUp && JUMP_PRESSED) {
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
	
		hSpeed = walkSpeed * MOVE_DIR;
		if (MOVE_DIR != 0 && tongue.allIn) {
			imgXScale = MOVE_DIR;
		}
		
		collision();
		
		tongue.step();
		
	break;
	case STATE.TONGETIED:
	
		grappleLength = min(point_distance(x, y, grappleX, grappleY), tongue.length);
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
				var newGrappleLength = min(grappleLength + grappleVSpeed * (keyboard_check(ord("S")) - keyboard_check(ord("W"))), tongue.length);
				var lenDelta = grappleLength - newGrappleLength
				grappleLength = newGrappleLength;
				if (lenDelta < 0 && (!place_meeting(x, y + 1, oGround))) {
					hSpeed += lengthdir_x(lenDelta, ang);
					vSpeed += lengthdir_y(lenDelta, ang);
				}
			}
			else if (keyboard_check_released(ord("S")) || keyboard_check_released(ord("W"))) {
				vSpeed = 0;
			}
			
		}
		
		// If you jump, exit tonguetied state
		if (preCoyTime > 0 && y >= grappleY) {
			
			imgAng = 0;
			imgYScale = 1;
			
			hSpeed = walkSpeed * MOVE_DIR;
			imgXScale = betterSign(grappleX - x);
			
			jump();
			collision();
			state = STATE.NORMAL
			tongue.step();
		}
		else {
			collisionGrapple();
			
			if (place_meeting(x, y + 1, oGround)) {
				imgAng = 0;
				imgYScale = 1;
				imgXScale = (x > grappleX) ? -1 : 1;
			}
			else if (place_meeting(x - 1, y, oGround) || place_meeting(x + 1, y, oGround)) {
				imgXScale = 1;
				imgAng = 90;
				imgYScale = (x > grappleX) ? -1 : 1;
			}
			else {
				vSpeed -= fallMag * sin(degtorad(fallAng));
				imgAng = point_direction(x, y, grappleX, grappleY);
				imgXScale = 1;
				imgYScale = (imgAng > 90 && imgAng < 270) ? -1 : 1;
			}
			
			tongue.grapple();
		}
		
	break;
	default:
		throw("Something went horribly wrong");
}

if (bbox_top > room_height + tongue.length || place_meeting(x, y, oEnemy)) {
	die();
}