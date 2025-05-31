hSpeed = 0;
vSpeed = 0;
launchSpeed = 25;
grav = 0.2;
depth += 10;

killsThrower = false;

launch = function(_angle) {
	hSpeed = lengthdir_x(launchSpeed, _angle);
	vSpeed = lengthdir_y(launchSpeed, _angle);
	state = SpikeState.flying;
	killsThrower = false;
}

getStuck = function() {
	state = SpikeState.stuck;
	if (generator != noone) {
		generator.instance = noone;
	}
}