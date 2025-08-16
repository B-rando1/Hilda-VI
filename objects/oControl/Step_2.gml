/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

if (instance_exists(oFade)) {
	audio_sound_gain(bgSound, 1 - oFade.fade, 0);
}

if (!global.pause) {
	var numEnemies = instance_number(oEnemy);
	nearestEnemies = [noone, noone, noone];
	with (oEnemy) {
		var NE = other.nearestEnemies;
		var dist = point_distance(oPlayer.x, oPlayer.y, x, y);
		for (var i = 0; i < array_length(NE); i ++) {
			if (NE[i] == noone || NE[i].dist > dist) {
				for (var j = array_length(NE) - 1; j > i; j --) {
					NE[j] = NE[j-1];
				}
				NE[i] = {id, dist};
				break;
			}
		}
	}

	var gain = 3;
	var mult = 0.000008;
	if (numEnemies == 0) {
		audio_sound_gain(enemySound1, 0, 0);
		audio_sound_gain(enemySound2, 0, 0);
		audio_sound_gain(enemySound3, 0, 0);
	}
	else if (numEnemies < 5) {
		audio_sound_gain(enemySound1, gain / (mult * power(nearestEnemies[0].dist, 2) + 1), 0)
		audio_sound_gain(enemySound2, 0, 0);
		audio_sound_gain(enemySound3, 0, 0);
	}
	else if (numEnemies < 10) {
		audio_sound_gain(enemySound1, gain / (mult * power(nearestEnemies[0].dist, 2) + 1), 0)
		audio_sound_gain(enemySound2, gain / (mult * power(nearestEnemies[1].dist, 2) + 1), 0);
		audio_sound_gain(enemySound3, 0, 0);
	}
	else {
		audio_sound_gain(enemySound1, gain / (mult * power(nearestEnemies[0].dist, 2) + 1), 0)
		audio_sound_gain(enemySound2, gain / (mult * power(nearestEnemies[1].dist, 2) + 1), 0);
		audio_sound_gain(enemySound3, gain / (mult * power(nearestEnemies[2].dist, 2) + 1), 0);
	}
}

var mouseActive = (mouse_x != prevMouseX || mouse_y != prevMouseY || mouse_check_button_pressed(mb_any));
if (keyboard_check(vk_anykey) || mouseActive) {
	noMoveTimer = 0;
} else {
	noMoveTimer = min(noMoveTimer + 1, 120);
}

if (global.pause) {
	cursor_sprite = -1;
} else if (oPlayer.aiming && oPlayer.inMouth != noone) {
	cursor_sprite = sMouseAim;
} else {
	cursor_sprite = sMouseTongue;
}

// Pause Menu
if (global.pause) {
	if (mouseActive) {
		for (var i = 0; i < array_length(menuButtons); i++) {
			menuButtons[i].step();
		}
	}
	if (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left)) {
		changeMenuFocused(menuFocused - 1);
	}
	if (keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right)) {
		changeMenuFocused(menuFocused + 1);
	}
	
	if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"))) {
		changeMenuFocused(0);
		unPause();
	}
	if (MENU_SELECT) {
		handleMenuButtonPressed();
	}
}
else if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"))) {
	pause();
}

prevMouseX = mouse_x;
prevMouseY = mouse_y;