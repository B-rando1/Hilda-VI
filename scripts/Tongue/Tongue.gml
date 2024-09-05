function Tongue(_carry, _x, _y) constructor {
	
	x = _x;
	y = _y;
	dir = 1;
	angle = 0;
	
	carry = _carry;
	var linkNum = 50;
	offset = 12;
	head = new Node(x, y, 0, self, 0, linkNum);
	
	length = linkNum * head.length + offset;
	
	goOut = false;
	allOut = false;
	allIn = true;
	
	tongueBuffer = 0;
	tongueBufferMax = 20;
	
	step = function() {
		
		if (TONGUE_PRESSED) {
			tongueBuffer = tongueBufferMax;
		}
		if (TONGUE_DOWN) {
			tongueBuffer = max(tongueBuffer - 1, 0);
		}
		else {
			tongueBuffer = 0;
		}
		
		if (allIn) {
			updateDir(betterSign(mouse_x - carry.x));
			var newAng = point_direction(x, y, mouse_x, mouse_y);
			head.updateAng(angle_difference(newAng, angle));
			angle = newAng;
		}
		else if (!goOut) {
			updateDir(carry.imgXScale);
		}
		
		x = carry.x + 12 * dir - 2 * (dir == 1);
		y = carry.y;
		
		if (allIn && tongueBuffer > 0) {
			tongueBuffer = 0;
			carry.imgXScale = dir;
			out();
		}
		else if (goOut) {
			out();
		}
		else if (!allIn) {
			in();
		}
		
		if (!allIn) {
			colls = collisions(oEnemy);
			for (var i = 0; i < ds_list_size(colls); i ++) {
				instance_destroy(ds_list_find_value(colls, i));
			}
			ds_list_destroy(colls);
		}
		
	}
	
	grapple = function() {
		
		angle = point_direction(carry.x, carry.y, carry.grappleX, carry.grappleY);
		var dist = point_distance(carry.x, carry.y, carry.grappleX, carry.grappleY) - offset;
		
		// TODO: get better mouth tracking abilities.
		x = carry.x + lengthdir_x(offset, angle)
		y = carry.y + lengthdir_y(offset, angle);
		
		if (dist > length) {
			show_debug_message("grapple length too long");
		}
		
		var dev = radtodeg(arccos(clamp(dist / length, 0, 1)));
		
		head.line(angle, dev, 1, carry.grappleX, carry.grappleY);
	}
	
	draw = function() {
		
		if (allIn) return;
		draw_set_colour(make_color_rgb(255, 125, 199));
		head.draw();
	}
	
	out = function() {
		
		goOut = true;
		allIn = false;
		head.out();
		
		colls = head.collisions(oGround);
		if (ds_list_size(colls) > 0) {
			setOut();
		}
		ds_list_destroy(colls);
		
	}
	
	in = function() {
		head.in(angle, 1);
	}
	
	setOut = function() {
		allOut = true;
		goOut = false;
	}
	
	setIn = function() {
		allIn = true;
		allOut = false;
		goOut = false;
		head.reset(angle, dir, 0);
	}
	
	startGrapple = function(_x, _y) {
		
		var dist = point_distance(carry.x, carry.y, _x, _y);
		if (dist < length - 1) {
			carry.state = STATE.TONGETIED;
			carry.grappleX = _x;
			carry.grappleY = _y;
			carry.jumpUp = false;
			setOut();
		}
	
	}
	
	collisions = function(_obj) {
		return head.collisions(_obj);
	}
	
	updateDir = function(_newDir) {
		if (_newDir != dir) {
			head.reset(angle, _newDir, 0);
			dir = _newDir;
		}
	}
	
}

function Node(_x, _y, _angle, _prev, _nodesDone, _nodesLeft) constructor {
	
	x = _x;
	y = _y;
	angle = _angle;
	
	length = 4;
	
	prev = _prev;
	
	var angDiff = (_nodesDone < 2) ? 0 : 30;
	var nextX = x + lengthdir_x(length, angle);
	var nextY = y + lengthdir_y(length, angle);
	next = (_nodesLeft > 0) ? new Node(nextX, nextY, _angle + angDiff, self, _nodesDone + 1, _nodesLeft - 1) : undefined;
	
	draw = function() {
		
		draw_line_width(x, y, x + lengthdir_x(length, angle), y + lengthdir_y(length, angle), 1.2);
		if (!is_undefined(next)) {
			draw_triangle(x, y, next.x, next.y, next.x + lengthdir_x(next.length, next.angle), next.y + lengthdir_y(next.length, next.angle), false);
			next.draw();
		}
		
	}
	
	reset = function(_angle, _scale, _nodesDone) {
		angle = _angle;
		var angDiff = (_nodesDone < 2) ? 0 : 30 * _scale;
		updatePos();
		if (!is_undefined(next)) {
			next.reset(_angle + angDiff, _scale, _nodesDone + 1);
		}
	}
	
	out = function() {
		
		var angDiff = lerp(0, angle_difference(prev.angle, angle), 0.8);
		angle += angDiff;
		updatePos();
		
		if (!is_undefined(next)) {
			next.out();
		}
		else if (abs(angle_difference(prev.angle, angle)) < 1) {
			setOut();
		}
		
		if (collision_line(x, y, x + lengthdir_x(length, angle), y + lengthdir_y(length, angle), oGround, false, true)) {
			startGrapple(x + lengthdir_x(length / 2, angle), y + lengthdir_y(length / 2, angle));
		}
		
	}
	
	in = function(_angle, _dir) {
		
		angle += angle_difference(_angle + 90 * _dir, angle) / 3;
		updatePos();
			
		if (!is_undefined(next)) {
			next.in(_angle, _dir * -1);
		}
		else if (abs(angle_difference(_angle + 90 * _dir, angle)) < 1) {
			setIn();
		}
		
	}
	
	line = function(_angle, _dev, _dir, _xTo, _yTo) {
		
		angle = _angle + _dev * _dir;
		
		if (next == undefined) {
			x = _xTo - lengthdir_x(length, angle);
			y = _yTo - lengthdir_y(length, angle);
		}
		else {
			next.line(_angle, _dev, _dir * -1, _xTo, _yTo);
			x = next.x - lengthdir_x(length, angle);
			y = next.y - lengthdir_y(length, angle);
		}
		
	}
	
	updateAng = function(_angle) {
		
		angle += _angle;
		updatePos();
		if (!is_undefined(next)) {
			next.updateAng(_angle);
		}
		
	}
	
	updatePos = function() {
		x = prev.x + lengthdir_x(length, prev.angle);
		y = prev.y + lengthdir_y(length, prev.angle);
	}
	
	setOut = function() {
		prev.setOut();
	}
	
	setIn = function() {
		prev.setIn();
	}
	
	startGrapple = function(_x, _y) {
		prev.startGrapple(_x, _y);
	}
	
	collisions = function(_obj) {
		
		colls = ds_list_create();
		with (_obj) {
			if (collision_line(other.x, other.y, other.x + lengthdir_x(other.length, other.angle), other.y + lengthdir_y(other.length, other.angle), self, false, false)) {
				ds_list_add(other.colls, self);
			}
		}
		
		if (!is_undefined(next)) {
			var nextColls = next.collisions(_obj);
			for (var i = 0; i < ds_list_size(nextColls); i ++) {
				ds_list_add(colls, ds_list_find_value(nextColls, i));
			}
			ds_list_destroy(nextColls);
		}
		
		return colls;
		
	}
	
}