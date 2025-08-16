/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

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
		draw_text_transformed(centerX, room_height * 0.85, "Right-click or press Esc or 'P' to go back.", 1/3, 1/3, 0);
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
		draw_text_transformed(centerX, room_height * 0.2 + 30, "A game by Brandon Bosman and his brother Zac", 1/3, 1/3, 0);
		
		draw_set_font(fH4);
		draw_text_transformed(centerX, room_height * 0.2 + 60, "Music from ZapSplat:", 1/3, 1/3, 0);
		draw_set_font(fTextBox);
		draw_text_transformed(centerX, room_height * 0.2 + 80, "Game music - action, fast paced Euro style house, rave, pumping with electronic wobble bass synth elements", 1/4, 1/4, 0);
		draw_text_transformed(centerX, room_height * 0.2 + 100, "Game music, action, urban groove, electro breakbeat with a funky electronic bass and record scratching", 1/4, 1/4, 0);
		draw_text_transformed(centerX, room_height * 0.2 + 120, "Game music, action, fun and funky electronic disco with wah guitars, electro bass and drums", 1/4, 1/4, 0);
		
		draw_set_font(fH4);
		draw_text_transformed(centerX, room_height * 0.2 + 150, "Sound Effects from FreeSound:", 1/3, 1/3, 0);
		draw_set_font(fTextBox);
		draw_text_transformed(centerX, room_height * 0.2 + 170, "CARTOON LICK 1.wav by kebermaknaan -- https://freesound.org/s/474365/ -- License: Attribution 4.0", 1/4, 1/4, 0);
		draw_text_transformed(centerX, room_height * 0.2 + 190, "Footsteps-Tile-Jump-06-From.wav by DWOBoyle -- https://freesound.org/s/458283/ -- License: Attribution 4.0", 1/4, 1/4, 0);
		draw_text_transformed(centerX, room_height * 0.2 + 210, "Jump to grass.WAV by 14FPanskaBubik_Lukas -- https://freesound.org/s/418553/ -- License: Creative Commons 0", 1/4, 1/4, 0);
		draw_text_transformed(centerX, room_height * 0.2 + 230, "C-SPENCE_KICK01.wav by HUMANOISEMAKER -- https://freesound.org/s/157409/ -- License: Creative Commons 0", 1/4, 1/4, 0);
		draw_text_transformed(centerX, room_height * 0.2 + 250, "Light Wing Flap by TurboFool -- https://freesound.org/s/561009/ -- License: Creative Commons 0", 1/4, 1/4, 0);
		draw_text_transformed(centerX, room_height * 0.2 + 270, "#5 Cardboard Scratch.wav by LittleLuigi -- https://freesound.org/s/364782/ -- License: Creative Commons 0", 1/4, 1/4, 0);
		draw_text_transformed(centerX, room_height * 0.2 + 290, "shimmer_synth_2.wav by wangzhuokun -- https://freesound.org/s/434599/ -- License: Creative Commons 0", 1/4, 1/4, 0);
		draw_text_transformed(centerX, room_height * 0.2 + 310, "menu click 1 by Tissman -- https://freesound.org/s/531852/ -- License: Creative Commons 0", 1/4, 1/4, 0);
		
		draw_set_halign(fa_center);
		draw_text_transformed(centerX, room_height * 0.85, "Right-click or press Esc or 'P' to go back.", 1/3, 1/3, 0);
		break;
}