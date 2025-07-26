switch (state) {
	case MenuState.opening:
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(c_white);
		draw_set_font(fH1);
		draw_text_transformed(centerX, room_height * 0.3, "Hilda VI", 1/3, 1/3, 0);
		draw_set_font(fTextBox);
		draw_text_transformed(centerX, room_height * 0.75, "Click or Press Space to Start", 1/3, 1/3, 0);
		break;
	case MenuState.main:
		for (var i = 0; i < array_length(mainButtons); i++) {
			mainButtons[i].draw();
		}
		break;
	case MenuState.levels:
		draw_set_alpha(0.65);
		draw_set_color(c_black);
		draw_rectangle(0, 50, room_width, room_height - 50, false);
		draw_set_alpha(1);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(fH2);
		draw_set_color(c_white);
		draw_text_transformed(centerX, room_height * 0.2, "Levels", 1/3, 1/3, 0);
		
		for (var i = 0; i < array_length(levelButtons); i++) {
			levelButtons[i].draw();
		}
		
		draw_set_color(c_white);
		draw_set_halign(fa_center);
		draw_set_font(fTextBox);
		draw_text_transformed(centerX, room_height * 0.85, "Right-click or press Esc to go back.", 1/3, 1/3, 0);
		break;
	case MenuState.settings:
		draw_set_alpha(0.65);
		draw_set_color(c_black);
		draw_rectangle(80, 0, room_width - 80, room_height, false);
		draw_set_alpha(1);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(fH2);
		draw_set_color(c_white);
		draw_text_transformed(centerX, room_height * 0.2, "Settings", 1/3, 1/3, 0);
		
		draw_set_halign(fa_center);
		draw_set_font(fTextBox);
		draw_text_transformed(centerX, room_height * 0.85, "Right-click or press Esc to go back.", 1/3, 1/3, 0);
		break;
	case MenuState.credits:
		draw_set_alpha(0.65);
		draw_set_color(c_black);
		draw_rectangle(80, 0, room_width - 80, room_height, false);
		
		draw_set_alpha(1);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_font(fH2);
		draw_set_color(c_white);
		draw_text_transformed(centerX, room_height * 0.2, "Credits", 1/3, 1/3, 0);
		
		draw_set_font(fTextBox);
		draw_set_halign(fa_left);
		draw_text_transformed(120, room_height * 0.2 + 50, "A game by Brandon Bosman and his brother Zac", 1/3, 1/3, 0);
		
		draw_set_halign(fa_center);
		draw_text_transformed(centerX, room_height * 0.85, "Right-click or press Esc to go back.", 1/3, 1/3, 0);
		break;
}