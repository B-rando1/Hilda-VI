/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

if ((!crossedOver && glow < 1) || (crossedOver && fade <= 0)) {
	glow += glowAmt;
} else {
	fade += fadeAmt;
}

if (glow <= 0 && crossedOver) {
	instance_destroy();
}
else if (fade >= 1 && !crossedOver) {
	glowAmt *= -1;
	fadeAmt *= -1;
	crossedOver = true;
	room_goto(newRoom);
}