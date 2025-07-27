
var centerX = oCamera.x;
var centerY = oCamera.y;
var width = oCamera.cWidth;
var height = oCamera.cHeight;
var scale = oCamera.cWidth / oCamera.cWidthNormal;

if (global.pause) {
	
	draw_set_color(c_black);
	draw_set_alpha(0.65);
	draw_rectangle(centerX - width / 2, centerY - height / 2, centerX + width / 2, centerY + height / 2, false);

	draw_set_alpha(1);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_font(fH2);
	draw_set_color(c_white);
	draw_text_transformed(centerX, centerY - height * 0.35, "Paused", 1/3 * scale, 1/3 * scale, 0);
	
	for (var i = 0; i < array_length(menuButtons); i++) {
		menuButtons[i].draw();
	}
	
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_font(fTextBox);
	draw_text_transformed(centerX, centerY + height * 0.42, "Press Esc to resume.", 1/3 * scale, 1/3 * scale, 0);
	
} else if (noMoveTimer >= 120) {
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fTextBox);
	draw_text_transformed(centerX - width / 2 + 40 * scale, centerY - height / 2 + 25 * scale, "Press Esc to pause", 1/3 * scale, 1/3 * scale, 0);
}