triggered = false;

trigger = function() {
	if (triggered) return;
	
	audio_play_sound(sndLevel_end, 50, false);
	triggered = true;
	var nextLevelCode = 0;
	switch (room) {
		case rmLevel1:
			nextLevelCode = 1;
			break;
		case rmLevel2:
			nextLevelCode = 2;
			break;
		case rmLevel3:
			nextLevelCode = 3;
			break;
		case rmLevel4:
			nextLevelCode = 4;
			break;
		case rmLevel5:
			nextLevelCode = 5;
			break;
	}
	if (nextLevelCode > global.settings.unlockedLevel) {
		updateSave("unlockedLevel", nextLevelCode);
	}
	instance_create_depth(0, 0, depth, oFade, {newRoom: room_next(room), fromOrb: true});
}