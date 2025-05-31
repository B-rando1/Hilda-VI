if (instance != noone && instance_exists(instance)) {
	return;
}
instance = noone;

if (waitTime == -1) {
	waitTime = delay;
}

waitTime --;

if (waitTime == -1) {
	instance = instance_create_depth(x, y, depth, objectType, {generator: id});
}
