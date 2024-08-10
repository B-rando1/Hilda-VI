function Whip(_carry, _x, _y) constructor {
	
	x = _x;
	y = _y;
	scale = 1;
	angle = 0;
	
	carry = _carry;
	var linkNum = 50;
	head = new Link(x, y, 0, self, 0, linkNum);
	
	length = linkNum * head.length;
	
	goOut = false;
	allOut = false;
	allIn = true;
	
	step = function() {
		
		x = carry.x;
		y = carry.y;
		
		if ((mouse_check_button_pressed(mb_right) && allIn) || goOut) {
			out();
		}
		else if (!allIn) {
			in();
		}
		else {
			
			var newAng = point_direction(x, y, mouse_x, mouse_y);
			head.updateAng(angle_difference(newAng, angle));
			angle = newAng;
			
			var newScale = (mouse_x - x < 0) ? -1 : 1;
			if (newScale != scale) {
				head.reset(angle, newScale, 0);
				scale = newScale;
			}
			
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
		
		x = carry.x;
		y = carry.y;
		
		angle = point_direction(carry.x, carry.y, carry.grappleX, carry.grappleY);
		var dist = point_distance(carry.x, carry.y, carry.grappleX, carry.grappleY);
		
		if (dist > length) {
			show_debug_message("grapple length too long");
		}
		
		var dev = radtodeg(arccos(min(dist / length, 1)));
		
		head.line(angle, dev, 1, carry.grappleX, carry.grappleY);
	}
	
	draw = function() {
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
	
	updatePos = function(_x, _y) {
		x = _x;
		y = _y;
	}
	
	setOut = function() {
		allOut = true;
		goOut = false;
	}
	
	setIn = function() {
		allIn = true;
		allOut = false;
		head.reset(angle, scale, 0);
	}
	
	startGrapple = function(_x, _y) {
		
		var dist = point_distance(carry.x, carry.y, _x, _y);
		if (dist < length - 1) {
			carry.state = STATE.GRAPPLE;
			carry.grappleX = _x;
			carry.grappleY = _y;
			carry.jumpUp = false;
			setOut();
		}
	
	}
	
	collisions = function(_obj) {
		return head.collisions(_obj);
	}
	
}

function Link(_x, _y, _angle, _prev, _nodesDone, _nodesLeft) constructor {
	
	x = _x;
	y = _y;
	angle = _angle;
	
	length = 4;
	
	prev = _prev;
	
	var angDiff = (_nodesDone < 2) ? 0 : 30;
	var nextX = x + lengthdir_x(length, angle);
	var nextY = y + lengthdir_y(length, angle);
	next = (_nodesLeft > 0) ? new Link(nextX, nextY, _angle + angDiff, self, _nodesDone + 1, _nodesLeft - 1) : undefined;
	
	draw = function() {
		
		draw_set_colour(c_white);
		draw_line_width(x, y, x + lengthdir_x(length, angle), y + lengthdir_y(length, angle), 1.2);
		if (!is_undefined(next)) {
			next.draw();
		}
		
	}
	
	reset = function(_angle, _scale, _nodesDone) {
		angle = _angle;
		var angDiff = (_nodesDone < 2) ? 0 : 30 * _scale;
		updatePos()
		if (!is_undefined(next)) {
			next.reset(_angle + angDiff, _scale, _nodesDone + 1);
		}
	}
	
	out = function() {
		
		var angDiff = lerp(0, angle_difference(prev.angle, angle), 0.8)
		angle += angDiff;//updateAng(angDiff);
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