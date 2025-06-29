if ((!crossedOver && glow < 1) || (crossedOver && fade <= 0)) {
	glow += glowAmt;
} else {
	fade += fadeAmt;
}

if (glow <= 0 && crossedOver) {
	instance_destroy();
}
else if (fade >= 1 && !crossedOver) {
	glowAmt *= -1;
	fadeAmt *= -1;
	crossedOver = true;
	room_goto(newRoom);
}