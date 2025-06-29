hSpeed = 0;
vSpeed = 0;
launchSpeed = 25;
grav = 0.2;
depth += 10;

flyingCounter = 0;
killsThrower = false;

launch = function(_angle) {
	hSpeed = lengthdir_x(launchSpeed, _angle);
	vSpeed = lengthdir_y(launchSpeed, _angle);
	state = SpikeState.flying;
	killsThrower = false;
}

getStuck = function() {
	if (place_meeting(x, y, oOrb)) {
		instance_destroy();
	}
	
	state = SpikeState.stuck;
	if (generator != noone) {
		generator.instance = noone;
	}
}

beDiscarded = function() {
	state = SpikeState.discarded;
	hspeed = oPlayer.hSpeed - 4 * oPlayer.imgXScale;
	vSpeed = oPlayer.vSpeed + 5;
}

