/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

function loadSave() {
    
    var defaults = {
        unlockedLevel : 0
    }
    var keys = variable_struct_get_names(defaults);
    global.settings = {};
    
    ini_open("save");
    
        for (var i = 0; i < array_length(keys); i++) {
            var key = keys[i];
            var val = ini_read_real("main", key, variable_struct_get(defaults, key));
            variable_struct_set(global.settings, key, val);
        }
    
    ini_close();
}

function updateSave(key, val) {
    
    variable_struct_set(global.settings, key, val);
    
    ini_open("save");
        ini_write_real("main", key, val);
    ini_close();
}