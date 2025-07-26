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