if (follow != noone && instance_exists(follow)) {
	xTo = clamp(follow.x, cWidth / 2, room_width - cWidth / 2);
	yTo = clamp(follow.y, cHeight / 2, room_height - cHeight / 2);
}

x = lerp(x, xTo, 0.45);
y = lerp(y, yTo, 0.45);

var vm = matrix_build_lookat(x, y, -200, x, y, 0, 0, 1, 0);
camera_set_view_mat(camera, vm);