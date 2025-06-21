if (ON_GROUND) {
	if (place_meeting(x, y + 1, oCheckpoint)) {
		safeX = x;
		safeY = y;
		with (instance_place(x, y, oCheckpoint)) {
			activate();
		}
	}
	postCoyTime = postCoyTimeMax;
	if (JUMP_PRESSED || preCoyTime > 0) {
		jump();
	}
	if (MOVE_DIR == 0) {
		image_speed = 0;
	}
	else {
		if (image_speed == 0) {
			image_index ++;
		}
		image_speed = 1;
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
	image_speed = 0;
	image_index = 0;
}

preCoyTime = max(preCoyTime - 1, 0);
postCoyTime = max(postCoyTime - 1, 0);

switch (state) {
	case STATE.NORMAL:
	
		var ax = getAccel(hSpeed, MOVE_DIR * walkSpeed, walkAccel);
		hSpeed = (hSpeed + ax) * walkDecel;
	
		if (MOVE_DIR != 0 && tongue.allIn) {
			imgXScale = MOVE_DIR;
		}
		
		collision();
		
		tongue.step();
		if (inMouth != noone && THROW_RELEASED) {
			inMouth.launch(point_direction(inMouth.x, inMouth.y, mouse_x, mouse_y));
			inMouth = noone;
		}
		
	break;
	case STATE.TONGETIED:
	
		grappleLength = min(point_distance(x, y, grappleX, grappleY), tongue.length);
		changeGL = false;
		var ang = point_direction(x, y, grappleX, grappleY);
		
		var fallAng = (x > grappleX) ? ang + 90 : ang - 90;
		var fallMag = fallGrav * cos(abs(degtorad(angle_difference(fallAng, 270))));
		
		if (ON_GROUND) {
			hSpeed = walkSpeed * (keyboard_check(ord("D")) - keyboard_check(ord("A")));
		}
		else {
			hSpeed += grappleHAccel * (keyboard_check(ord("D")) - keyboard_check(ord("A")));
			if (y > grappleY && !ON_GROUND) {
				hSpeed += fallMag * cos(degtorad(fallAng));
			}
		}
	
		if (y >= grappleY) {
			
			if (keyboard_check(ord("S")) || keyboard_check(ord("W"))) {
				var newGrappleLength = clamp(grappleLength + grappleVSpeed * (keyboard_check(ord("S")) - keyboard_check(ord("W"))), grappleVSpeed, tongue.length);
				var lenDelta = grappleLength - newGrappleLength;
				grappleLength = newGrappleLength;
				if (lenDelta < 0 && (!ON_GROUND)) {
					hSpeed += lengthdir_x(lenDelta, ang);
					vSpeed += lengthdir_y(lenDelta, ang);
				}
			}
			else if (keyboard_check_released(ord("S")) || keyboard_check_released(ord("W"))) {
				vSpeed = 0;
			}
			
		}
		
		// If you jump, exit tonguetied state
		if (preCoyTime > 0 && (y >= grappleY || place_meeting(x + 1, y, pGround) || place_meeting(x - 1, y, pGround))) {
			
			//hSpeed = walkSpeed * MOVE_DIR;
			imgXScale = betterSign(grappleX - x);
			
			jump();
			collision();
			tongue.step();
		}
		else {
			collisionGrapple();
			
			if (ON_GROUND) {
				imgAng = 0;
				imgYScale = 1;
				imgXScale = (x > grappleX) ? -1 : 1;
			}
			else if (place_meeting(x - 1, y, pGround) || place_meeting(x + 1, y, pGround)) {
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

hSpeed = clamp(hSpeed, -maxSpeed, maxSpeed);
vSpeed = clamp(vSpeed, -maxSpeed, maxSpeed);

if (bbox_top > room_height + tongue.length || place_meeting(x, y, oDeath)) {
	die();
}
else if (place_meeting(x, y, oEnemy)) {
	with (instance_place(x, y, oEnemy)) {
		if (state != EnemyState.beingEaten && state != EnemyState.dying) {
			other.die();
		}
	}
}
else if (place_meeting(x, y, oSpike)) {
	with (instance_place(x, y, oSpike)) {
		if (state == SpikeState.flying && killsThrower) {
			other.die();
		}
	}
}

if (inMouth == noone) {
	sprite_index = sPlayer;
}
else {
	sprite_index = sPlayerMouthFull;
}

throwTrajectory = [];
if (inMouth != noone && THROW_DOWN) {
	var trajX = inMouth.x;
	var trajY = inMouth.y;
	array_push(throwTrajectory, {x: trajX, y: trajY});
	var _angle = point_direction(inMouth.x, inMouth.y, mouse_x, mouse_y);
	var trajHSpeed = lengthdir_x(inMouth.launchSpeed, _angle);
	var trajVSpeed = lengthdir_y(inMouth.launchSpeed, _angle);
	
	for (var i = 0; i < 20; i ++) {
		trajX += trajHSpeed;
		trajY += trajVSpeed;
		
		array_push(throwTrajectory, {x: trajX, y: trajY});
		trajVSpeed += inMouth.grav;
		var lastPoint = throwTrajectory[array_length(throwTrajectory)-1];
		if (collision_line(lastPoint.x, lastPoint.y, trajX, trajY, pGround, false, true) || collision_line(lastPoint.x, lastPoint.y, trajX, trajY, oDeath, false, true)) {
			break;
		}
	}
}

var orb = collision_rectangle(bbox_left - 1, bbox_top - 1, bbox_right + 1, bbox_bottom + 1, oOrb, true, true);
if (orb != noone) {
	orb.trigger();
}