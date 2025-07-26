var mouseActive = (mouse_x != prevMouseX || mouse_y != prevMouseY || mouse_check_button_pressed(mb_any));
switch (state) {
	case MenuState.opening:
		if (MENU_SELECT) {
			state = MenuState.main;
		}
		break;
	case MenuState.main:
		if (mouseActive) {
			for (var i = 0; i < array_length(mainButtons); i++) {
				mainButtons[i].step();
			}
			if (MENU_BACK) {
				changeMainFocused(0);
				state = MenuState.opening;
			}
		} else {
			if (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up)) {
				changeMainFocused(mainFocused - 1);
			}
			if (keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down)) {
				changeMainFocused(mainFocused + 1);
			}
		}
		
		if (MENU_SELECT) {
			handleMainButtonPressed();
		}
		break;
	case MenuState.levels:
		if (mouseActive) {
			for (var i = 0; i < array_length(levelButtons); i++) {
				levelButtons[i].step();
			}
			if (MENU_BACK) {
				changeLevelFocused(0);
				state = MenuState.main;
			}
		} else {
			if (keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down)) {
				changeLevelFocused(levelFocused + (levelFocused < 3 ? 3 : -3));
			}
			if (keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left)) {
				changeLevelFocused(levelFocused == 0 ? 2 : (levelFocused == 3 ? 5 : levelFocused - 1));
			}
			if (keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right)) {
				changeLevelFocused(levelFocused == 2 ? 0 : (levelFocused == 5 ? 3 : levelFocused + 1));
			}
		}
		
		if (MENU_SELECT) {
			handleLevelButtonPressed();
		}
		break;
	case MenuState.settings:
		if (MENU_BACK) {
			state = MenuState.main;
		}
		break;
	case MenuState.credits:
	if (MENU_BACK) {
		state = MenuState.main;
	}
		break;
}
prevMouseX = mouse_x;
prevMouseY = mouse_y;