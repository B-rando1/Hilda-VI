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
distanceThreshold = 300;

myAccel = 0.5;

maxSpeed = 6;
maxFleeSpeed = 3;
attackAng = 0;

blinkFrames = [120, 160];
blinkTimeTotal = 200;
blinkLength = 8;

getGrabbed = function() {
	spikeDir = -0.25;
	state = EnemyState.grabbed;
}

startBeingEaten = function() {
	if (state == EnemyState.beingEaten) return;
	state = EnemyState.beingEaten;
	spikeDir = -1;
	hSpeed = 0;
	vSpeed = 0;
}

startDying = function() {
	if (state == EnemyState.dying) return;
	if (state == EnemyState.grabbed || state == EnemyState.beingEaten) {
		with (oPlayer) {
			grappleID = noone;
			tongue.grappleID = noone;
			jump()
		}
	}
	state = EnemyState.dying;
	sprite_index = sEnemyDie;
	image_index = 0;
	spikeDir = -1;
}