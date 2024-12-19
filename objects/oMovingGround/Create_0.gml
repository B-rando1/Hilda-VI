hSpeed = dir * 2 * endX * 32 / (period * 60);
vSpeed = dir * 2 * endY * 32 / (period * 60);
progress = progressPct * period * 60 / 2;

myGround = instance_create_depth(x, y, depth, groundType,{
	image_xscale : image_xscale,
	image_yscale : image_yscale,
	image_angle  : image_angle
})