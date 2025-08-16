/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

cWidthNormal = 720;
cHeightNormal = 576;
cWidthTarget = cWidthNormal;
cHeightTarget = cHeightNormal;

cWidth = cWidthNormal;
cHeight = cHeightNormal;

// Get layer IDs
trees_1 = layer_get_id("Trees_1");
trees_2 = layer_get_id("Trees_2");
trees_3 = layer_get_id("Trees_3");
sandDune = layer_get_id("SandDune");

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

inMouthTimer = 0;

camera = camera_create_view(x - cWidth / 2, y - cHeight / 2, cWidth, cHeight);
view_camera[0] = camera;