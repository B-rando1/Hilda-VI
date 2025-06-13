draw_set_color(c_gray);
for (var i = 0; i < array_length(throwTrajectory) - 1; i ++) {
	draw_line_width(throwTrajectory[i].x, throwTrajectory[i].y, throwTrajectory[i+1].x, throwTrajectory[i+1].y, 2);
}

draw_sprite_ext(sprite_index, image_index, x, y, imgXScale, imgYScale, imgAng, image_blend, image_alpha);
