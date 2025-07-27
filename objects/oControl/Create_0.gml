window_set_cursor(cr_none);
prevMouseX = mouse_x;
prevMouseY = mouse_y;

global.pause = false;
noMoveTimer = 0;
depth -= 150;

pause = function() {
	global.pause = true;
	
	window_set_cursor(cr_default);
	
	var centerX = oCamera.x;
	var centerY = oCamera.y;
	var scale = oCamera.cWidth / oCamera.cWidthNormal;
	for (var i = 0; i < array_length(menuButtons); i++) {
		menuButtons[i].update(centerX + 160 * (i - 1.5) * scale, centerY + 30 * (i - 1.5) * scale, scale);
	}
}

unPause = function() {
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

menuButtonTexts = ["Resume", "Settings", "Restart", "Menu"];
menuButtons = [];
for (var i = 0; i < array_length(menuButtonTexts); i++) {
	array_push(menuButtons, new Button(
		0, 0,
		menuButtonTexts[i], i, id, changeMenuFocused
	));
}
changeMenuFocused(0);

handleMenuButtonPressed = function() {
	switch (menuFocused) {
		case 0:
			unPause();
			break;
		case 1:
			//TODO
			break;
		case 2:
			instance_create_depth(0, 0, depth, oFade, {newRoom: room});
			break;
		case 3:
			instance_create_depth(0, 0, depth, oFade, {newRoom: rmMenu});
			break;
	}
}