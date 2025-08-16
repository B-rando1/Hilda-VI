enum EnemyState {
	idle,
	attack,
	grabbed,
	beingEaten,
	dying
}

enum SpikeState {
	idle,
	grabbed,
	mouth,
	flying,
	stuck,
	discarded
}

randomize();
loadSave();
global.pause = false;
global.mute = false;
global.gain = 1.0;

instance_create_depth(0, 0, depth, oFade, {newRoom: room_next(room), crossedOver: true});

room_goto_next();