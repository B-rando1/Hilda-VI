walkAccel = 1.0;
walkDecel = 0.8;
walkSpeed = 3 / walkDecel;
jumpSpeed = 10;

grav = 0.39;
fallGrav = 0.7;

#macro ON_GROUND place_meeting(x, y + 1, pGround)

#macro MOVE_DIR (gamepad_is_connected(0) ? gamepad_button_check(0, gp_padr) - gamepad_button_check(0, gp_padl) : (keyboard_check(ord("D")) - keyboard_check(ord("A"))))
#macro JUMP_PRESSED (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space) || (gamepad_is_connected(0) && (gamepad_button_check_pressed(0, gp_shoulderr) || gamepad_button_check_pressed(0, gp_shoulderl))))
#macro JUMP_DOWN (mouse_check_button(mb_left) || keyboard_check(vk_space) || (gamepad_is_connected(0) && (gamepad_button_check(0, gp_shoulderr) || gamepad_button_check(0, gp_shoulderl))))
#macro TONGUE_PRESSED (mouse_check_button_pressed(mb_right) || keyboard_check_pressed(vk_alt) || (gamepad_is_connected(0) && (gamepad_button_check_pressed(0, gp_shoulderrb) || gamepad_button_check_pressed(0, gp_shoulderlb))))
#macro TONGUE_DOWN (mouse_check_button(mb_right) || keyboard_check(vk_alt) || (gamepad_is_connected(0) && (gamepad_button_check(0, gp_shoulderrb) || gamepad_button_check(0, gp_shoulderlb))))

jumpUp = false;

preCoyTime = 0;
preCoyTimeMax = 20;
postCoyTime = 0;
postCoyTimeMax = 20;

hSpeed = 0;
vSpeed = 0;
maxSpeed = 15;

safeX = x;
safeY = y;

imgAng = 0;
imgXScale = 1;
imgYScale = 1;

enum STATE {
	NORMAL,
	TONGETIED
}

state = STATE.NORMAL;

grappleX = 0;
grappleY = 0;
grappleLength = 0;
changeGL = false;
grappleHAccel = 0.25;
grappleVSpeed = 3;

tongue = new Tongue(self, x, y);

jump = function() {
	
	imgAng = 0;
	imgYScale = 1;
	jumpUp = true;
	postCoyTime = 0;
	preCoyTime = 0;
	
	if (state == STATE.TONGETIED && !ON_GROUND && y >= grappleY) {
		var pullVel = lengthdir_y(jumpSpeed, point_direction(x, y, grappleX, grappleY));
		var closeVel = (-jumpSpeed - pullVel) * (1 / (10 * sqr(grappleLength / tongue.length) + 1));
		show_debug_message("pullVel: " + string(pullVel));
		show_debug_message("closeVel: " + string(closeVel));
		vSpeed += pullVel + closeVel;
	}
	else {
		vSpeed = -jumpSpeed;
	}
	
	state = STATE.NORMAL;
	
}

collision = function() {
	
	if (place_meeting(x + hSpeed, y, pGround)) {
		while (!place_meeting(x + sign(hSpeed), y, pGround)) {
			x += sign(hSpeed);
		}
		hSpeed = 0;
	}
	x += hSpeed;

	if (place_meeting(x, y + vSpeed, pGround)) {
		while (!place_meeting(x, y + sign(vSpeed), pGround)) {
			y += sign(vSpeed);
		}
		vSpeed = 0;
	}
	y += vSpeed;
	
}

collisionGrapple = function() {
	
	collision();
	
	if (ON_GROUND &&
			(MOVE_DIR != 0 ||
			(point_distance(x, y, grappleX, grappleY) > grappleLength &&
				abs(angle_difference(90, point_direction(x, y, grappleX, grappleY))) > 20))) {
		
		if (MOVE_DIR != 0 && point_distance(x, y, grappleX, grappleY) <= tongue.length) {
			return;
		}
		
		var ang = point_direction(x, y, grappleX, grappleY);
		var sqrtPart = sqrt(max(sqr(grappleLength) - sqr(y - grappleY), 0));
		var circX = (x > grappleX) ? grappleX + sqrtPart : grappleX - sqrtPart;
		
		if (!place_meeting(circX, y, pGround)) {
			x = circX;
			y = y;
		}
		else {
			
			var oldX = x - 1;
			var oldY = y - 1;
			while (point_distance(x, y, grappleX, grappleY) > grappleLength &&
				abs(angle_difference(point_direction(x, y, grappleX, grappleY), ang)) < 90 &&
				(!floatEq(x, oldX) || !floatEq(y, oldY))) {
				
				oldX = x;
				oldY = y;
				hSpeed = lengthdir_x(1, ang);
				vSpeed = lengthdir_y(1, ang);
				collision();
			}
			
		}
	}
	else {
		
		if (ON_GROUND) {
			grappleLength = min(grappleLength, point_distance(x, y, grappleX, grappleY));
		}
	
		if (point_distance(x, y, grappleX, grappleY) <= grappleLength) {
			return;
		}
	
		var ang = point_direction(x, y, grappleX, grappleY);
		if (!place_meeting(grappleX - lengthdir_x(grappleLength, ang), grappleY - lengthdir_y(grappleLength, ang), pGround)) {
			x = grappleX - lengthdir_x(grappleLength, ang);
			y = grappleY - lengthdir_y(grappleLength, ang);
		}
		else {
			
			var sqrtPart = sqrt(max(sqr(grappleLength) - sqr(x - grappleX), 0));
			var circY = (y > grappleY) ? grappleY + sqrtPart : grappleY - sqrtPart;
			
			if (place_meeting(x + sign(grappleX - x), y, pGround) && !place_meeting(x, circY, pGround)) {
				y = circY;
			}
			else {
			
				var oldX = x - 1;
				var oldY = y - 1;
				while (point_distance(x, y, grappleX, grappleY) > grappleLength &&
					abs(angle_difference(point_direction(x, y, grappleX, grappleY), ang)) < 90 &&
					(!floatEq(x, oldX) || !floatEq(y, oldY))) {
				
					oldX = x;
					oldY = y;
					hSpeed = lengthdir_x(1, ang);
					vSpeed = lengthdir_y(1, ang);
					collision();
				}
			
			}
		}
	}  
	
	vSpeed = y - yprevious;
	hSpeed = x - xprevious;

}

getAccel = function(_current, _target, _accel) {
	if (_target - _current > 0) {
		if (_target - (_current + _accel) < 0)
			return _target - _current;
		return _accel;
	}
	else if (_target - _current < 0) {
		if (_target - (_current - _accel) > 0)
			return _target - _current;
		return -_accel;
	}
	return 0;
}

die = function() {
	
	x = safeX;
	y = safeY;
	hSpeed = 0;
	vSpeed = 0;
	preCoyTime = 0;
	postCoyTime = 0;
	imgAng = 0;
	imgXScale = 1;
	imgYScale = 1;
	state = STATE.NORMAL;
	tongue.setIn();
	
}
