/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

draw_set_font(fTextBox);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var width = string_width(message) / 3 + 14;
var height = string_height(message) / 3 + 8;

draw_set_alpha(0.65);
draw_set_colour(c_black);
draw_rectangle(x - width / 2, y - height / 2, x + width / 2, y + height / 2, false);

draw_set_color(c_white);
draw_set_alpha(1);
draw_text_transformed(x, y, message, 1/3, 1/3, 0);