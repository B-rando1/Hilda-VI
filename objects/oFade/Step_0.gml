if ((!crossedOver && glow < 1) || (crossedOver && fade <= 0)) {
	glow += glowAmt;
	show_debug_message("glowing")
} else {
	fade += fadeAmt;
	show_debug_message("fading")
}

if (glow <= 0 && crossedOver) {
	show_debug_message("done")
	instance_destroy();
}
else if (fade >= 1 && !crossedOver) {
	show_debug_message("crossing over")
	glowAmt *= -1;
	fadeAmt *= -1;
	crossedOver = true;
	room_goto(newRoom);
}