if (!setSprite && collision_point(x + 16, y + 48, oPoison, false, true) == noone) {
	// Set image_index to random value
	set_image_index_propogate(random_range(0, sprite_get_number(sprite_index) - 1));
	setSprite = true;
}
