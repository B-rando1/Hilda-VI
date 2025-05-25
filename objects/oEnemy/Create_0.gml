reset = function() {
	x = xstart;
	y = ystart;
	
	state = EnemyState.idle;

	hSpeed = 0;
	vSpeed = 0;
	mySpeed = 0;
	
	sprite_index = sEnemy;
	imgAng = 0;
	image_xscale = 1;
	image_yscale = 1;
	
	// Blinking
	blinkTimer = 0;
	
	spikeFrame = -1.0;
	spikeDir = 0.0;
}

reset();

anchorX = x;
anchorY = y;
distanceThreshold = 150;

myAccel = 0.5;

maxSpeed = 6;
maxFleeSpeed = 3;
attackAng = 0;

blinkFrames = [120, 160];
blinkTimeTotal = 200;
blinkLength = 8;

getStuck = function() {
	spikeDir = -0.25;
	state = EnemyState.stuck;
}

die = function() {
	if (state == EnemyState.dying) return;
	state = EnemyState.dying;
	spikeDir = -1;
	hSpeed = 0;
	vSpeed = 0;
}