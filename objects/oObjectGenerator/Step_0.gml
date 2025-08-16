/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

if (global.pause) return;

if (instance != noone && instance_exists(instance)) {
	return;
}
instance = noone;

if (waitTime < 0) {
	waitTime = delay;
}

waitTime -= global.timeScale;

if (waitTime < 0) {
	instance = instance_create_depth(x, y, depth, objectType, {generator: id});
}
