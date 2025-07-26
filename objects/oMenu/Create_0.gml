enum MenuState {
	opening,
	main,
	levels,
	settings,
	credits
}

#macro MENU_SELECT (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter))
#macro MENU_BACK (mouse_check_button_pressed(mb_right) || keyboard_check_pressed(vk_escape))

state = MenuState.opening;
centerX = room_width / 2;
centerY = room_height / 2;

prevMouseX = mouse_x;
prevMouseY = mouse_y;

unlockedLevel = 0; // TODO: get from save file

// Main buttons
mainFocused = -1;
changeMainFocused = function(newIdx) {
	if (mainFocused == newIdx) return;
	if (newIdx < 0) newIdx = array_length(mainButtons) - 1;
	if (newIdx > array_length(mainButtons) - 1) newIdx = 0;
	if (mainFocused != -1) {
		mainButtons[mainFocused].focused = false;
	}
	mainButtons[newIdx].focused = true;
	mainFocused = newIdx;
}

mainButtonTexts = ["Levels", "Settings", "Credits"];
mainButtons = [];
for (var i = 0; i < array_length(mainButtonTexts); i++) {
	array_push(mainButtons, new Button(
		centerX, centerY + 100 * (i - 1),
		mainButtonTexts[i], i, id, changeMainFocused
	));
}
changeMainFocused(0);

handleMainButtonPressed = function() {
	switch (mainFocused) {
		case 0:
			state = MenuState.levels;
			break;
		case 1:
			state = MenuState.settings;
			break;
		case 2:
			state = MenuState.credits;
			break;
	}
}

// Level Select
levelFocused = -1;
changeLevelFocused = function(newIdx) {
	if (levelFocused == newIdx) return;
	if (newIdx < 0) newIdx = array_length(levelButtons) - 1;
	if (newIdx > array_length(levelButtons) - 1) newIdx = 0;
	if (newIdx > unlockedLevel) return;
	if (levelFocused != -1) {
		levelButtons[levelFocused].focused = false;
	}
	levelButtons[newIdx].focused = true;
	levelFocused = newIdx;
}

levelButtonTexts = [];
for (var i = 1; i <= 5; i++) {
	array_push(levelButtonTexts, "Level " + string(i));
}
array_push(levelButtonTexts, "Bonus Level");
levelButtons = [];
for (var i = 0; i < array_length(levelButtonTexts); i++) {
	array_push(levelButtons, new Button(
		centerX + 150 * ((i  % 3) - 1), centerY + (i < 3 ? -50 : 50),
		levelButtonTexts[i], i, id, changeLevelFocused,
		i > unlockedLevel
	));
}
changeLevelFocused(0);

handleLevelButtonPressed = function() {
	switch (levelFocused) {
		case 0:
			instance_create_depth(0, 0, depth, oFade, {newRoom: rmLevel1});
			break;
		case 1:
			instance_create_depth(0, 0, depth, oFade, {newRoom: rmLevel2});
			break;
		case 2:
			instance_create_depth(0, 0, depth, oFade, {newRoom: rmLevel3});
			break;
		case 3:
			instance_create_depth(0, 0, depth, oFade, {newRoom: rmLevel4});
			break;
		case 4:
			instance_create_depth(0, 0, depth, oFade, {newRoom: rmLevel5});
			break;
		case 5:
			// instance_create_depth(0, 0, depth, oFade, {newRoom: "TODO"});
			break;
	}
}