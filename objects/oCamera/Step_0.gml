var cWidthTarget = cWidthNormal;
var cHeightTarget = cHeightNormal;

var zoomArea = oPlayer.check_instance_place(x, y, oZoomArea);
if (zoomArea != noone) {
	cWidthTarget *= zoomArea.mult;
	cHeightTarget *= zoomArea.mult;
}

cWidth = lerp(cWidth, cWidthTarget, 0.05);
cHeight = lerp(cHeight, cHeightTarget, 0.05);

camera = camera_create_view(x - cWidth / 2, y - cHeight / 2, cWidth, cHeight);
view_camera[0] = camera;

if (follow != noone && instance_exists(follow)) {
	xTo = clamp(follow.x, cWidth / 2, room_width - cWidth / 2);
	yTo = clamp(follow.y, cHeight / 2, room_height - cHeight / 2);
}

x = lerp(x, xTo, 0.45);
y = lerp(y, yTo, 0.45);

var vm = matrix_build_lookat(x, y, -200, x, y, 0, 0, 1, 0);
camera_set_view_mat(camera, vm);