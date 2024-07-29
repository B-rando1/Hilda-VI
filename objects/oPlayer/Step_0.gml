hSpeed = walkSpeed * (keyboard_check(ord("D")) - keyboard_check(ord("A")));

if (place_meeting(x, y + 1, oGround)) {
	if (mouse_check_button_pressed(mb_left)) {
		vSpeed = -jumpSpeed;
		jumpUp = true;
	}
}
else {
	if (!mouse_check_button(mb_left) || vSpeed > 0) {
		jumpUp = false;
	}
	vSpeed += jumpUp ? grav : fallGrav;
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

whip.step();