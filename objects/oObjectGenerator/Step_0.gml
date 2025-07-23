if (instance != noone && instance_exists(instance)) {
	return;
}
instance = noone;

if (waitTime < 0) {
	waitTime = delay;
}

waitTime -= global.timeScale;

if (waitTime < 0) {
	instance = instance_create_depth(x, y, depth, objectType, {generator: id});
}
