/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

if (global.pause) return;

with (myGround) {
	hSpeed = other.hSpeed;
	vSpeed = other.vSpeed;
	
	if (object_is_ancestor(object_index, pGround)) {
		
		var carryPlayer = false;
		if (collision_rectangle(bbox_left, bbox_top - 1, bbox_right, bbox_top, oPlayer, false, true) != noone) {
			carryPlayer = true;
		}

		if (carryPlayer) {
	
			with (oPlayer) {
				move(other.hSpeed, other.vSpeed);
			}
			x += hSpeed;
			y += vSpeed;
	
			with (oPlayer) {
				while (place_meeting(x, y, other)) {
					y -= 0.1;
				}
				if (place_meeting(x, y, pGround)) {
					die();
				}
				if (bbox_right > other.bbox_left && bbox_left < other.bbox_right) {
					while (!place_meeting(x, y + 0.1, pGround)) {
						y += 0.1;
					}
				}
			}
		}
		else {
	
			if (place_meeting(x + hSpeed, y, oPlayer)) {
				while (place_meeting(x + hSpeed, y, oPlayer)) {
					oPlayer.x += sign(hSpeed);
				}
				with (oPlayer) {
					if (place_meeting(x, y, pGround)) {
						show_debug_message("Player pushed into wall (vertical)")
						die();
					}
				}
			}
			x += hSpeed;
			if (place_meeting(x, y + vSpeed, oPlayer)) {
				while (place_meeting(x, y + vSpeed, oPlayer)) {
					oPlayer.y += sign(vSpeed);
				}
				with (oPlayer) {
					if (place_meeting(x, y, pGround)) {
						show_debug_message("Player pushed into wall (vertical)")
						die();
					}
				}
			}
			y += vSpeed;
		}

		if (oPlayer.state == STATE.TONGETIED && oPlayer.grappleID == id) {
			with (oPlayer) {
				grappleX += other.hSpeed;
				grappleY += other.vSpeed;
				var amt_moved = move(0, other.vSpeed);
				xprevious += amt_moved[0];
				yprevious += amt_moved[1];
			}
		}
	}
	else {
		x += hSpeed;
		y += vSpeed;
	}
}

// Needs to go last
progress += dir;
if ((progress < 0) || (progress > period * 60 / 2)) {
	hSpeed *= -1;
	vSpeed *= -1;
	dir *= -1;
}