reset = function() {
	x = xstart;
	y = ystart;
	
	state = EnemyState.idle;

	hSpeed = 0;
	vSpeed = 0;
	
	// Blinking
	blinkTimer = 0;
	blinkFrames = [120, 160];
	blinkTimeTotal = 200;
	blinkLength = 8;
}

reset();


mySpeed = 0;
myAccel = 0.5;

imgAng = 0;

maxSpeed = 6;
attackAng = 0;

die = function() {
	if (state == EnemyState.dying) return;
	state = EnemyState.dying;
	sprite_index = sEnemyDie;
	image_index = 0;
	image_speed = 0;
}