/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_mix;

vec3 yellow = vec3(255.0 / 255.0, 248.0 / 255.0, 153.0 / 255.0);

void main()
{
	vec4 texColor = texture2D( gm_BaseTexture, v_vTexcoord );
	vec4 finalColor = mix(texColor, vec4(yellow, texColor.a), u_mix);
	gl_FragColor = v_vColour * finalColor;
}
