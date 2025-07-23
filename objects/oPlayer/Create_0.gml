depth += 1;

global.timeScale = 1;

walkAccel = 1.0;
walkDecel = 0.8;
walkSpeed = 3 / walkDecel;
jumpSpeed = 10;

grav = 0.39;
fallGrav = 0.7;

#macro ON_GROUND (place_meeting(x, y + 1, pGround) || (!place_meeting(x, y, oOneWayWall) && place_meeting(x, y + 1, oOneWayWall)))

#macro MOVE_DIR (gamepad_is_connected(0) ? gamepad_button_check(0, gp_padr) - gamepad_button_check(0, gp_padl) : (keyboard_check(ord("D")) - keyboard_check(ord("A"))))
#macro JUMP_PRESSED (keyboard_check_pressed(vk_space) || (gamepad_is_connected(0) && (gamepad_button_check_pressed(0, gp_shoulderr) || gamepad_button_check_pressed(0, gp_shoulderl))))
#macro JUMP_DOWN (keyboard_check(vk_space) || (gamepad_is_connected(0) && (gamepad_button_check(0, gp_shoulderr) || gamepad_button_check(0, gp_shoulderl))))
#macro TONGUE_PRESSED (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_alt) || (gamepad_is_connected(0) && (gamepad_button_check_pressed(0, gp_shoulderrb) || gamepad_button_check_pressed(0, gp_shoulderlb))))
#macro TONGUE_DOWN (mouse_check_button(mb_left) || keyboard_check(vk_alt) || (gamepad_is_connected(0) && (gamepad_button_check(0, gp_shoulderrb) || gamepad_button_check(0, gp_shoulderlb))))
#macro THROW_DOWN (mouse_check_button(mb_right) || keyboard_check(vk_shift) || (gamepad_is_connected(0) && (gamepad_button_check(0, gp_face3))))
#macro THROW_RELEASED (mouse_check_button_released(mb_right) || keyboard_check_released(vk_shift) || (gamepad_is_connected(0) && (gamepad_button_check_released(0, gp_face3))))

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
mixUnif = shader_get_uniform(shPlayerYellow, "u_mix");

enum STATE {
	NORMAL,
	TONGETIED
}

state = STATE.NORMAL;

grappleX = 0;
grappleY = 0;
grappleID = noone;

grappleLength = 0;
changeGL = false;
grappleHAccel = 0.25;
grappleVSpeed = 3;

tongue = new Tongue(self, x, y);
instance_create_depth(0, 0, depth, oTongueDrawer);
inMouth = noone;
throwTrajectory = [];

jump = function() {
	
	imgAng = 0;
	imgYScale = 1;
	jumpUp = true;
	postCoyTime = 0;
	preCoyTime = 0;
	
	if (state == STATE.TONGETIED && !ON_GROUND && y >= grappleY) {
		var pullVel = lengthdir_y(jumpSpeed, point_direction(x, y, grappleX, grappleY));
		var closeVel = (-jumpSpeed - pullVel) * (1 / (10 * sqr(grappleLength / tongue.length) + 1));
		vSpeed += pullVel + closeVel;
	}
	else {
		vSpeed = -jumpSpeed;
	}
	
	if (grappleID != noone && instance_exists(grappleID) && grappleID.object_index == oEnemy) {
		grappleID.state = EnemyState.beingEaten;
	}
	state = STATE.NORMAL;
	
}

move = function(_hSpeed, _vSpeed) {
	
	var scaledHSpeed = _hSpeed * global.timeScale;
	var scaledVSpeed = _vSpeed * global.timeScale;
	var collideWithOneWay = (_vSpeed > 0 && !place_meeting(x, y, oOneWayWall));
	
	if ((place_meeting(x + scaledHSpeed, y, pGround) || (collideWithOneWay && place_meeting(x + scaledHSpeed, y, oOneWayWall))) && scaledHSpeed != 0) {
		while (!place_meeting(x + sign(scaledHSpeed), y, pGround) && (!collideWithOneWay || !place_meeting(x + sign(scaledHSpeed), y, oOneWayWall))) {
			x += sign(scaledHSpeed) * 0.1;
		}
		_hSpeed = 0;
		scaledHSpeed = 0;
	}
	x += scaledHSpeed;

	if ((place_meeting(x, y + scaledVSpeed, pGround) || (collideWithOneWay && place_meeting(x, y + scaledVSpeed, oOneWayWall))) && scaledVSpeed != 0) {
		while (!place_meeting(x, y + sign(scaledVSpeed), pGround) && (!collideWithOneWay || !place_meeting(x, y + sign(scaledVSpeed), oOneWayWall))) {
			y += sign(scaledVSpeed) * 0.1;
		}
		_vSpeed = 0;
		scaledVSpeed = 0;
	}
	y += scaledVSpeed;
	
	if (place_meeting(x, y, pGround)) {
		show_debug_message("stuck in wall in move function");
		die();
	}
	
	return [_hSpeed, _vSpeed];
	
}

collision = function() {
	
	speedVec = move(hSpeed, vSpeed);
	hSpeed = speedVec[0];
	vSpeed = speedVec[1];
	
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

moveGrapple = function(moveX, moveY) {
	grappleX += moveX;
	grappleY += moveY;
	var amt_moved = move(0, moveY);
	xprevious += amt_moved[0];
	yprevious += amt_moved[1];
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
	grappleID = noone;
	tongue.setIn();
	
	if (inMouth != noone) {
		instance_destroy(inMouth);
	}
	inMouth = noone;
	
	with (oEnemy) {
		reset();
	}
	
}

check_instance_place = function (_x, _y, _obj) {
	return instance_place(_x, _y, _obj);
}
