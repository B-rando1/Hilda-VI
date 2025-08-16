/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

glow = 0;
fade = 0;
glowAmt = 0.15;
fadeAmt = 0.05;
if (crossedOver) {
	glow = 1;
	fade = 1;
	glowAmt *= -1;
	fadeAmt *= -1;
}
depth -= 150;