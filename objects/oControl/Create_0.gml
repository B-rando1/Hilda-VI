window_set_cursor(cr_none);
prevMouseX = mouse_x;
prevMouseY = mouse_y;

bgSound = audio_play_sound(room == rmLevelBonus ? sndLevelBonus : sndLevel, 100, true);
enemySound1 = audio_play_sound(sndEnemy_fly, 60, true, 0);
enemySound2 = audio_play_sound(sndEnemy_fly, 7, true, 0, 0.9);
enemySound3 = audio_play_sound(sndEnemy_fly, 7, true, 0, 1.5);

nearestEnemies = [noone, noone, noone];

global.pause = false;
noMoveTimer = 0;
depth -= 150;

pause = function() {
	audio_play_sound(sndMenu_select, 10, false, 1/0.4);
	global.pause = true;
	oPlayer.aiming = false;
	
	global.gain = 0.4;
	audio_master_gain(global.mute ? 0 : 0.4);
	
	window_set_cursor(cr_default);
	
	var centerX = oCamera.x;
	var centerY = oCamera.y;
	var scale = oCamera.cWidth / oCamera.cWidthNormal;
	for (var i = 0; i < array_length(menuButtons); i++) {
		menuButtons[i].update(centerX + 160 * (i - 1.5) * scale, centerY + 30 * (i - 1.5) * scale, scale);
	}
}

unPause = function() {
	audio_play_sound(sndMenu_select, 10, false);
	global.gain = 1;
	audio_master_gain(global.mute ? 0 : 1);
	window_set_cursor(cr_none);
	global.pause = false;
}

// Menu buttons
menuFocused = -1;
changeMenuFocused = function(newIdx) {
	if (menuFocused == newIdx) return;
	if (newIdx < 0) newIdx = array_length(menuButtons) - 1;
	if (newIdx > array_length(menuButtons) - 1) newIdx = 0;
	if (menuFocused != -1) {
		menuButtons[menuFocused].focused = false;
	}
	menuButtons[newIdx].focused = true;
	menuFocused = newIdx;
}

menuButtonTexts = ["Resume", global.mute ? "Unmute" : "Mute", "Restart", "Menu"];
menuButtons = [];
for (var i = 0; i < array_length(menuButtonTexts); i++) {
	array_push(menuButtons, new Button(
		0, 0,
		menuButtonTexts[i], i, id, changeMenuFocused
	));
}
changeMenuFocused(0);

handleMenuButtonPressed = function() {
	audio_play_sound(sndMenu_select, 10, false);
	switch (menuFocused) {
		case 0:
			unPause();
			break;
		case 1:
			global.mute = !global.mute;
			audio_master_gain(global.mute ? 0 : global.gain);
			menuButtons[1].text = global.mute ? "Unmute" : "Mute";
			break;
		case 2:
			instance_create_depth(0, 0, depth, oFade, {newRoom: room});
			break;
		case 3:
			instance_create_depth(0, 0, depth, oFade, {newRoom: rmMenu});
			break;
	}
}