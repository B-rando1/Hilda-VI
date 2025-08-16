/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

function floatEq(_f1, _f2) {
	return abs(_f1 - _f2) < 1;
}

function betterSign(_n) {
	return sign(_n) == 0 ? 1 : sign(_n);
}