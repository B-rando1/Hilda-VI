draw_self()

var draw_eyes = true;

if (state == EnemyState.idle) {
	for (var i = 0; i < array_length(blinkFrames); i ++) {
		var diff = blinkTimer - blinkFrames[i];
		if (diff >= 0 && diff < blinkLength) {
			draw_eyes = false;
		}
	}
}

if (draw_eyes) {
	draw_sprite_ext(sEnemyEyes, 0, x, y, 1, 1, image_angle, c_white, image_alpha);
}
else {
	draw_sprite_ext(sEnemyEyes, 1, x, y, 1, 1, image_angle, c_white, image_alpha);
}