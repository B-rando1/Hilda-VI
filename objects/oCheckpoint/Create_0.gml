/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

depth += 20;
active = false;

activate = function() {
	
	with (oCheckpoint) {
		deactivate();
	}
	
	active = true;
	image_index = 1;
	
}

deactivate = function() {
	active = false;
	image_index = 0;
}