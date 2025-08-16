/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

nextTime --;
if (nextTime <= 0) {
	updateTargets();
}

angleDiff = lerp(angleDiff, angleDiffTarget, 0.1);
zoom = lerp(zoom, zoomTarget, 0.1);
angle += angleDiff;