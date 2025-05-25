if (spikeFrame >= 0) {
	draw_sprite_ext(sEnemySpike, spikeFrame, x, y, image_xscale, image_yscale, imgAng, c_white, image_alpha);
}

draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, imgAng, c_white, image_alpha);

var draw_eyes = true;

if (state == EnemyState.idle) {
	for (var i = 0; i < array_length(blinkFrames); i ++) {
		var diff = blinkTimer - blinkFrames[i];
		if (diff >= 0 && diff < blinkLength) {
			draw_eyes = false;
		}
	}
}

if (state == EnemyState.stuck) {
	draw_sprite_ext(sEnemyEyesScared, 0, x, y, 1, 1, imgAng, c_white, image_alpha);
}
if (state == EnemyState.dying) {
	
}
else if (draw_eyes) {
	draw_sprite_ext(sEnemyEyes, 0, x, y, 1, 1, imgAng, c_white, image_alpha);
}
else {
	draw_sprite_ext(sEnemyEyes, 1, x, y, 1, 1, imgAng, c_white, image_alpha);
}