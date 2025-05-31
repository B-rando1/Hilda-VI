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