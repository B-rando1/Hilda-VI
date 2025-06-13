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

room_goto_next();