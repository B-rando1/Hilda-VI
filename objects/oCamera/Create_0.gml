cWidth = 720;
cHeight = 576;

if (follow != noone && instance_exists(follow)) {
	if (follow != noone && instance_exists(follow)) {
		xTo = clamp(follow.x, cWidth / 2, room_width - cWidth / 2);
		yTo = clamp(follow.y, cHeight / 2, room_height - cHeight / 2);
	}
}
else {
	xTo = x;
	yTo = y;
}
x = xTo;
y = yTo;

camera = camera_create_view(x - cWidth / 2, y - cHeight / 2, cWidth, cHeight);
view_camera[0] = camera;