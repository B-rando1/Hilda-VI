hSpeed = dir * 2 * endX * 32 / (period * 60);
vSpeed = dir * 2 * endY * 32 / (period * 60);
progress = progressPct * period * 60 / 2;

myGround = instance_create_depth(x, y, depth, groundType);

myGround.image_xscale = image_xscale * sprite_get_width(sprite_index) / sprite_get_width(myGround.sprite_index);
myGround.image_yscale = image_yscale * sprite_get_height(sprite_index) /  sprite_get_height(myGround.sprite_index);
myGround.image_angle = image_angle;