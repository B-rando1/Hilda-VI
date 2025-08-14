offsetX = -11.5;
offsetY = 6.5;
length = point_distance(0, 0, offsetX, offsetY);
dir = point_direction(0, 0, offsetX, offsetY);

centerX = room_width / 2;
centerY = room_height / 2;

depth += 5;

angle = 0;
zoom = 0;

zoomTarget = 0;
angleDiff = 0;
angleDiffTarget = 0;

nextTime = 0;

updateTargets = function() {
	angleDiffTarget = random_range(10, 25);
	zoomTarget = random_range(1, 25);
	nextTime = irandom_range(15, 120);
}

updateTargets();
angleDiff = angleDiffTarget;
zoom = zoomTarget;
