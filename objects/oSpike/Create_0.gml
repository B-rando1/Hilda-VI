hSpeed = 0;
vSpeed = 0;
launchSpeed = 15;
grav = 0.3;
depth += 10;

launch = function(_angle) {
	hSpeed = lengthdir_x(launchSpeed, _angle);
	vSpeed = lengthdir_y(launchSpeed, _angle);
	state = SpikeState.flying;
}