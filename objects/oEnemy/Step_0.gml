if (place_meeting(x, y, oDeath)) {
	instance_destroy();
}
else if (place_meeting(x, y, oSpike)) {
	with (instance_place(x, y, oSpike)) {
		if (state == SpikeState.flying) {
			instance_destroy(other);
		}
	}
}

var playerDist = point_distance(anchorX, anchorY, oPlayer.x, oPlayer.y);

if (state == EnemyState.idle && playerDist < distanceThreshold) {
	state = EnemyState.attack;
	mySpeed = 0;
	attackAng = point_direction(x, y, oPlayer.x, oPlayer.y);
	spikeDir = 0.25;
	spikeFrame = max(spikeFrame, -spikeDir);
}
else if (state == EnemyState.attack && playerDist > distanceThreshold) {
	state = EnemyState.idle;
	spikeDir = -0.25;
}

if (state == EnemyState.idle) {
	var returnDist = point_distance(x, y, anchorX, anchorY);
	var returnAng = point_direction(x, y, anchorX, anchorY);
	var returnSpeed = maxSpeed * (returnDist / distanceThreshold) / 2;
	mySpeed = max(mySpeed - myAccel, 0);
	hSpeed = lengthdir_x(mySpeed, attackAng) + lengthdir_x(returnSpeed, returnAng) + 0.75 * sin(19 * current_time / 8000)  + 0.25 * sin(50 * current_time / 1000);
	vSpeed = lengthdir_y(mySpeed, attackAng) + lengthdir_y(returnSpeed, returnAng) + 0.4 * sin(23 * current_time / 12000) + 0.1 * sin(70 * current_time / 900);
	imgAng = -2 * hSpeed;
}
else if (state == EnemyState.attack) {
	var playerAng = point_direction(x, y, oPlayer.x, oPlayer.y);
	mySpeed = min(mySpeed + myAccel, maxSpeed);
	attackAng = attackAng + lerp(0, angle_difference(playerAng, attackAng), 0.15);
	hSpeed = lengthdir_x(mySpeed, attackAng);
	vSpeed = lengthdir_y(mySpeed, attackAng);
	imgAng = attackAng + 90;
}
else if (state == EnemyState.grabbed) {
	var returnXDist = anchorX - x;
	var returnXSpeed = maxSpeed * (returnXDist / distanceThreshold) / 2;
	hSpeed = returnXSpeed + 0.75 * sin(19 * current_time / 8000)  + 0.25 * sin(50 * current_time / 1000);
	vSpeed = max(-maxFleeSpeed, vSpeed - myAccel) + 0.4 * sin(23 * current_time / 12000) + 0.1 * sin(70 * current_time / 900);
	imgAng = -2 * hSpeed;
}
else if (state == EnemyState.dying) {
	if (place_meeting(x, y, oPlayer)) {
		oPlayer.inMouth = instance_create_depth(x, y, depth, oSpike, {state: SpikeState.mouth});
		instance_destroy();
	}
	var scale = min(image_xscale, lerp(image_xscale, playerDist / (2 * oPlayer.tongue.length) + 0.5, 0.8));
	image_xscale = scale;
	image_yscale = scale;
}
	
// Blinking stuff
blinkTimer = (blinkTimer + 1) % blinkTimeTotal;
spikeFrame += spikeDir;
if (spikeFrame < 0 || spikeFrame >= sprite_get_number(sEnemySpike)) {
	if (spikeDir > 0) {
		spikeFrame = sprite_get_number(sEnemySpike) - 1;
	}
	spikeDir = 0;
}

// Collide and move
if (place_meeting(x + hSpeed, y, pGround)) {
	while (!place_meeting(x + sign(hSpeed), y, pGround)) {
		x += sign(hSpeed);
	}
	hSpeed = 0;
}
x += hSpeed;

if (place_meeting(x, y + vSpeed, pGround)) {
	while (!place_meeting(x, y + sign(vSpeed), pGround)) {
		y += sign(vSpeed);
	}
	vSpeed = 0;
}
y += vSpeed;

if (state == EnemyState.grabbed) {
	oPlayer.moveGrapple(x - xprevious, y - yprevious);
}
