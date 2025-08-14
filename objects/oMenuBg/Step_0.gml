nextTime --;
if (nextTime <= 0) {
	updateTargets();
}

angleDiff = lerp(angleDiff, angleDiffTarget, 0.1);
zoom = lerp(zoom, zoomTarget, 0.1);
angle += angleDiff;