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

instance_create_depth(0, 0, depth, oFade, {newRoom: room_next(room), fade: 1, crossedOver: true});

room_goto_next();