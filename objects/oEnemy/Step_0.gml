/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

image_speed = global.pause ? 0 : global.timeScale;

if (global.pause) return;

if (place_meeting(x, y, oPoison)) {
	startDying();
}
else {
	var spike = instance_place(x, y, oSpike);
	if (spike != noone && spike.state == SpikeState.flying && state != EnemyState.dying) {
		audio_play_sound(sndSpike_hit_thing, 12, false);
		startDying();
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
	hSpeed = lengthdir_x(mySpeed, attackAng) + lengthdir_x(returnSpeed, returnAng) + 0.75 * sin(19 * current_time * global.timeScale / 8000)  + 0.25 * sin(50 * current_time * global.timeScale / 1000);
	vSpeed = lengthdir_y(mySpeed, attackAng) + lengthdir_y(returnSpeed, returnAng) + 0.4 * sin(23 * current_time * global.timeScale / 12000) + 0.1 * sin(70 * current_time * global.timeScale / 900);
	imgAng = -2 * hSpeed;
}
else if (state == EnemyState.attack) {
	var playerAng = point_direction(x, y, oPlayer.x, oPlayer.y);
	mySpeed = min(mySpeed + myAccel * global.timeScale, maxSpeed);
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
else if (state == EnemyState.beingEaten) {
	if (place_meeting(x, y, oPlayer)) {
		oPlayer.inMouth = instance_create_depth(x, y, depth, oSpike, {state: SpikeState.mouth});
		audio_play_sound(sndSpike_hit_thing, 12, false);
		instance_destroy(); // Don't replace with startDying()
	}
	var scale = min(image_xscale, lerp(image_xscale, playerDist / (2 * oPlayer.tongue.length) + 0.5, 0.8));
	image_xscale = scale;
	image_yscale = scale;
}
else if (state == EnemyState.dying) {
	if (image_index == sprite_get_number(sEnemyDie) - 1) {
		instance_destroy();
	}
}
	
// Blinking stuff
blinkTimer = (blinkTimer + global.timeScale) % blinkTimeTotal;
spikeFrame += spikeDir * global.timeScale;
if (spikeFrame < 0 || spikeFrame >= sprite_get_number(sEnemySpike)) {
	if (spikeDir > 0) {
		spikeFrame = sprite_get_number(sEnemySpike) - 1;
	}
	spikeDir = 0;
}

// Collide and move
var scaledHSpeed = hSpeed * global.timeScale;
var scaledVSpeed = vSpeed * global.timeScale;

if (place_meeting(x + scaledHSpeed, y, pGround)) {
	while (!place_meeting(x + sign(scaledHSpeed), y, pGround)) {
		x += sign(scaledHSpeed);
	}
	scaledHSpeed = 0;
	hSpeed = 0;
}
x += scaledHSpeed;

if (place_meeting(x, y + scaledVSpeed, pGround)) {
	while (!place_meeting(x, y + sign(scaledVSpeed), pGround)) {
		y += sign(scaledVSpeed);
	}
	scaledVSpeed = 0;
	vSpeed = 0;
}
y += scaledVSpeed;

if (state == EnemyState.grabbed) {
	oPlayer.moveGrapple(x - xprevious, y - yprevious);
}
