fade += fadeAmt;

if (fade <= 0 && crossedOver) {
	instance_destroy();
}
else if (fade >= 1 && !crossedOver) {
	fadeAmt *= -1;
	crossedOver = true;
	room_goto(newRoom);
}