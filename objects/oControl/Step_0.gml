var mouseActive = (mouse_x != prevMouseX || mouse_y != prevMouseY || mouse_check_button_pressed(mb_any));
if (keyboard_check(vk_anykey) || mouseActive) {
	noMoveTimer = 0;
} else {
	noMoveTimer = min(noMoveTimer + 1, 120);
}

if (THROW_DOWN && oPlayer.inMouth != noone) {
	cursor_sprite = sMouseAim;
}
else {
	cursor_sprite = sMouseTongue;
}

// Pause Menu
if (global.pause) {
	if (mouseActive) {
		for (var i = 0; i < array_length(menuButtons); i++) {
			menuButtons[i].step();
		}
	} else {
		if (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up)) {
			changeMenuFocused(menuFocused - 1);
		}
		if (keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down)) {
			changeMenuFocused(menuFocused + 1);
		}
	}
	
	if (keyboard_check_pressed(vk_escape)) {
		changeMenuFocused(0);
		unPause();
	}
	if (MENU_SELECT) {
		handleMenuButtonPressed();
	}
}
else if (keyboard_check_pressed(vk_escape)) {
	pause();
}

prevMouseX = mouse_x;
prevMouseY = mouse_y;