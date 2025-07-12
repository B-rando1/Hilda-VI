cWidthTarget = cWidthNormal;
cHeightTarget = cHeightNormal;

inMouthTimer = max(inMouthTimer - 1, 0);

if (THROW_DOWN) {
	inMouthTimer = 5;
}

if (inMouthTimer > 0) {
	cWidthTarget *= 2.5;
	cHeightTarget *= 2.5;
}
else {
	with (oSpike) {
		if (state == SpikeState.flying) {
			other.cWidthTarget *= 2.5;
			other.cHeightTarget *= 2.5;
			break;
		}
	}
}

cWidth = lerp(cWidth, cWidthTarget, 0.05);
cHeight = lerp(cHeight, cHeightTarget, 0.05);

camera = camera_create_view(x - cWidth / 2, y - cHeight / 2, cWidth, cHeight);
view_camera[0] = camera;

if (follow != noone && instance_exists(follow)) {
	xTo = follow.x;
	yTo = follow.y;
}

x = clamp(lerp(x, xTo, 0.45), cWidth / 2, room_width - cWidth / 2);;
y = clamp(lerp(y, yTo, 0.45), cHeight / 2, room_height - cHeight / 2);

var vm = matrix_build_lookat(x, y, -200, x, y, 0, 0, 1, 0);
camera_set_view_mat(camera, vm);