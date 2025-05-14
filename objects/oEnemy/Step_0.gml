var playerDist = point_distance(x, y, oPlayer.x, oPlayer.y);

if (state == EnemyState.idle && playerDist < 150) {
	state = EnemyState.attack;
	mySpeed = 0;
	attackAng = point_direction(x, y, oPlayer.x, oPlayer.y);
}
else if (state == EnemyState.attack && playerDist > 300) {
	state = EnemyState.idle;
}

if (state == EnemyState.idle) {
	mySpeed = max(mySpeed - myAccel, 0);
	hSpeed = lengthdir_x(mySpeed, attackAng) + 0.75 * sin(19 * current_time / 8000)  + 0.25 * sin(50 * current_time / 1000);
	vSpeed = lengthdir_y(mySpeed, attackAng) + 0.4 * sin(23 * current_time / 12000) + 0.1 * sin(70 * current_time / 900);
	image_angle = -2 * hSpeed;
}
else if (state == EnemyState.attack) {
	var playerAng = point_direction(x, y, oPlayer.x, oPlayer.y);
	mySpeed = min(mySpeed + myAccel, maxSpeed);
	attackAng = attackAng + lerp(0, angle_difference(playerAng, attackAng), 0.15);
	hSpeed = lengthdir_x(mySpeed, attackAng);
	vSpeed = lengthdir_y(mySpeed, attackAng);
	image_angle = attackAng + 90;
}

x += hSpeed;
y += vSpeed;

// Blinking stuff
blinkTimer = (blinkTimer + 1) % blinkTimeTotal;