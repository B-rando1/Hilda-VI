/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

var mix = instance_exists(oFade) && oFade.fromOrb ? oFade.glow : 0;
var tongueColor = {r: 255, g: 125, b: 199};
var yellowColor = {r: 255, g: 248, b: 153};
var color = {
	r: lerp(tongueColor.r, yellowColor.r, mix),
	g: lerp(tongueColor.g, yellowColor.g, mix),
	b: lerp(tongueColor.b, yellowColor.b, mix)
}

oPlayer.tongue.draw(make_color_rgb(color.r, color.g, color.b));
if (oPlayer.state == STATE.TONGETIED) {
	draw_line_width(oPlayer.tongue.head.x, oPlayer.tongue.head.y, oPlayer.x, oPlayer.y, 1.2);
}
