triggered = false;

trigger = function() {
	if (triggered) return;
	triggered = true;
	instance_create_depth(0, 0, depth, oFade, {newRoom: room_next(room)});
}