offset = 20 + 34;
setSprite = false;

set_image_index_propogate = function(idx) {
	image_index = idx;
	var above = collision_point(x + 16, y - 16, oPoison, false, true)
	if (above != noone) {
		above.set_image_index_propogate((image_index + offset) % sprite_get_number(sprite_index));
	}
	setSprite = true;
}

var centerX = x + 16;
var centerY = y + 16;
var width = 32;
var height = 32;

linesFrame = 0;

var left = (collision_point(centerX - width, centerY, oPoison, false, true) == noone);
var right = (collision_point(centerX + width, centerY, oPoison, false, true) == noone);
var bottom = (collision_point(centerX, centerY + height, oPoison, false, true) == noone);
var top = (collision_point(centerX, centerY - height, oPoison, false, true) == noone);

switch (left + right + top + bottom) {
	case 0:
		linesFrame = 0;
		break;
	case 1:
		if (right) linesFrame = 1;
		else if (top) linesFrame = 2;
		else if (left) linesFrame = 3;
		else if (bottom) linesFrame = 4;
		break;
	case 2:
		if (right) {
			if (top) linesFrame = 5;
			else if (left) linesFrame = 6;
			else if (bottom) linesFrame = 7;
		}
		else if (top) {
			if (left) linesFrame = 8;
			else if (bottom) linesFrame = 9;
		}
		else if (left) {
			// bottom == true
			linesFrame = 10;
		}
		break;
	case 3:
		if (!right) linesFrame = 11;
		else if (!top) linesFrame = 12;
		else if (!left) linesFrame = 13;
		else if (!bottom) linesFrame = 14;
		break;
	case 4:
		linesFrame = 15
		break;
}
