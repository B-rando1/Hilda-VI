if (state == EnemyState.dying) {
	hSpeed = lerp(hSpeed, 0, 0.1);
	vSpeed = lerp(vSpeed, 0, 0.1);
}
else {
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
	
	// Blinking stuff
	blinkTimer = (blinkTimer + 1) % blinkTimeTotal;
}

if (place_meeting(x + hSpeed, y, oGround)) {
	while (!place_meeting(x + sign(hSpeed), y, oGround)) {
		x += sign(hSpeed);
	}
	hSpeed = 0;
}
x += hSpeed;

if (place_meeting(x, y + vSpeed, oGround)) {
	while (!place_meeting(x, y + sign(vSpeed), oGround)) {
		y += sign(vSpeed);
	}
	vSpeed = 0;
}
y += vSpeed;
