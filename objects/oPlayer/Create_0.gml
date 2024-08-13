walkSpeed = 3;
jumpSpeed = 10;

grav = 0.39;
fallGrav = 0.7;

#macro JUMP_PRESSED (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space))
#macro JUMP_DOWN (mouse_check_button(mb_left) || keyboard_check(vk_space))
jumpUp = false;

preCoyTime = 0;
preCoyTimeMax = 20;
postCoyTime = 0;
postCoyTimeMax = 20;

hSpeed = 0;
vSpeed = 0;

imgAng = 0;
imgXScale = 1;
imgYScale = 1;

enum STATE {
	NORMAL,
	GRAPPLE
}

state = STATE.NORMAL;

grappleX = 0;
grappleY = 0;
grappleLength = 0;
changeGL = false;
grappleHAccel = 0.2;
grappleVSpeed = 2.5;

whip = new Whip(self, x, y);

jump = function() {
	vSpeed = -jumpSpeed;
	jumpUp = true;
	postCoyTime = 0;
	preCoyTime = 0;
	state = STATE.NORMAL;
}

collision = function() {
	
	if (place_meeting(x + hSpeed, y, oGround)) {
		while (!place_meeting(x + sign(hSpeed), y, oGround)) {
			x += sign(hSpeed);
		}
		hSpeed = 0;
	}
	x += hSpeed;

	if (place_meeting(x, y + vSpeed, oGround)) {
		while (!place_meeting(x, y + sign(vSpeed), oGround)) {
			y += sign(vSpeed);
		}
		vSpeed = 0;
	}
	y += vSpeed;
	
}

collisionGrapple = function() {
	
	collision()
	
	if (place_meeting(x, y + 1, oGround)) {
		if (point_distance(x, y, grappleX, grappleY) <= whip.length) {
			return;
		}
		
		var ang = point_direction(x, y, grappleX, grappleY);
		var sqrtPart = sqrt(max(sqr(whip.length) - sqr(y - grappleY), 0));
		var circX = (x > grappleX) ? grappleX + sqrtPart : grappleX - sqrtPart;
		
		if (!place_meeting(circX, y, oGround)) {
			x = circX;
			y = y;
		}
		else {
			
			var oldX = x - 1;
			var oldY = y - 1;
			while (point_distance(x, y, grappleX, grappleY) > whip.length &&
				abs(angle_difference(point_direction(x, y, grappleX, grappleY), ang)) < 90 &&
				(!floatEq(x, oldX) || !floatEq(y, oldY))) {
				
				oldX = x;
				oldY = y;
				hSpeed = lengthdir_x(1, ang);
				vSpeed = lengthdir_y(1, ang);
				collision();
			}
			
		}
	
		vSpeed = y - yprevious;
		hSpeed = x - xprevious;
	}
	else {
	
		if (point_distance(x, y, grappleX, grappleY) <= grappleLength) {
			return;
		}
	
		var ang = point_direction(x, y, grappleX, grappleY);
		if (!place_meeting(grappleX - lengthdir_x(grappleLength, ang), grappleY - lengthdir_y(grappleLength, ang), oGround)) {
			x = grappleX - lengthdir_x(grappleLength, ang);
			y = grappleY - lengthdir_y(grappleLength, ang);
		}
		else {
			
			var sqrtPart = sqrt(max(sqr(grappleLength) - sqr(x - grappleX), 0));
			var circY = (y > grappleY) ? grappleY + sqrtPart : grappleY - sqrtPart;
			
			if (place_meeting(x + sign(grappleX - x), y, oGround) && !place_meeting(x, circY, oGround)) {
				x = x;
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

die = function() {
	game_restart();
}

floatEq = function(_f1, _f2) {
	return abs(_f1 - _f2) < 1;
}
