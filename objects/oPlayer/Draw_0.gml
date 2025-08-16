/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

draw_set_color(c_gray);
for (var i = 0; i < array_length(throwTrajectory) - 1; i ++) {
	draw_line_width(throwTrajectory[i].x, throwTrajectory[i].y, throwTrajectory[i+1].x, throwTrajectory[i+1].y, 2);
}

if (instance_exists(oFade) && oFade.fromOrb) {
	shader_set(shPlayerYellow);
	shader_set_uniform_f(mixUnif, oFade.glow);
}

draw_sprite_ext(sprite_index, image_index, x, y, imgXScale, imgYScale, imgAng, image_blend, image_alpha);
shader_reset();
