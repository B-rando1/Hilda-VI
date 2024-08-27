if (ON_GROUND) {
	hSpeed = 0;
	if (sitTimer++ > sitTime) {
		hSpeed = clamp((oPlayer.x - x) / tof, -moveSpeed, moveSpeed);
		vSpeed = -jumpSpeed;
		sitTimer = 0;
		setSitTime();
	}
}
else {
	vSpeed += grav;
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