walkSpeed = 3;
jumpSpeed = 10;

grav = 0.39;
fallGrav = 0.7;

jumpUp = false;

preCoyTime = 0;
preCoyTimeMax = 20;
postCoyTime = 0;
postCoyTimeMax = 20;

hSpeed = 0;
vSpeed = 0;

enum STATE {
	NORMAL,
	GRAPPLE
}

state = STATE.NORMAL;

grappleX = 0;
grappleY = 0;
grappleLength = 0;
changeGL = false;
grappleHAccel = 0.1;
grappleVSpeed = 2.5;

whip = new Whip(self, x, y);

jump = function() {
	vSpeed = -jumpSpeed;
	jumpUp = true;
	postCoyTime = 0;
	preCoyTime = 0;
}

global.grapplePoints = [];
with (oGround) {
	array_push(global.grapplePoints, [bbox_left, bbox_top], [bbox_right, bbox_top]);
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
	
	if (point_distance(x, y, grappleX, grappleY) > grappleLength) {
	
		var ang = point_direction(x, y, grappleX, grappleY);
		if (!place_meeting(grappleX - lengthdir_x(grappleLength, ang), grappleY - lengthdir_y(grappleLength, ang), oGround)) {
			x = grappleX - lengthdir_x(grappleLength, ang);
			y = grappleY - lengthdir_y(grappleLength, ang);
		}
		else {
			var oldX = x - 1;
			var oldY = y - 1;
			while (point_distance(x, y, grappleX, grappleY) > grappleLength && (!floatEq(x, oldX) || !floatEq(y, oldY))) {
				show_debug_message(string(random(1)));
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

}

floatEq = function(_f1, _f2) {
	return abs(_f1 - _f2) < 1;
}
