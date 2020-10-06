event_inherited();

model.x = x;
model.y = y;
model.z = z;
model.update();

if (instance_exists(obj_camera))
	depth = obj_camera.depth - 1;

// Check For Crashes When There Are No Crashes Below Us
if (GRID_CRASHES[# u, v] == undefined) {		
	// Check For Ramps, Cars, Cones, and Pianos
	if (obj_cursor.selected_object != id && state != "crash" && abs(z - target_z) <= 1 && target_z >= -UNIT_SIZE * 0.5) {
		// Car
		if (state != "crash") {
			var _car = collision_circle(x, y, 5, obj_car, false, false);
			if (_car != undefined && _car != noone && obj_cursor.selected_object != _car) {
				if (_car.state != "crash" && obj_cursor.selected_object != _car)
					_car.do_crash();
				do_crash();
			}
		}
		// Ramp
		if (state != "crash") {
			var _ramp = collision_circle(target_x, target_y, 5, obj_ramp, false, false);
			if (_ramp != undefined && _ramp != noone && obj_cursor.selected_object != _ramp) {
				if (_ramp.state != "crash" && obj_cursor.selected_object != _ramp)
					_ramp.do_crash();
				do_crash();
			}
		}
		
		// Cone
		if (state != "crash") {
			var _cone = collision_circle(target_x, target_y, 5, obj_cone, false, false);
			if (_cone != undefined && _cone != noone && obj_cursor.selected_object != _cone) {
				if (_cone.state != "crash" && obj_cursor.selected_object != _cone)
					_cone.do_crash();
				do_crash();
			}
		}
		
		// Pianos
		if (state != "crash") {
			var _piano = collision_circle(target_x, target_y, 5, obj_piano, false, false);
			if (_piano != undefined && _piano != noone && obj_cursor.selected_object != _piano) {
				if (_piano.state != "crash" && obj_cursor.selected_object != _piano && _piano.target_z >= target_z)
					_piano.do_crash();
				do_crash();
			}
		}
	}
	// Check For Ground
	if (obj_cursor.selected_object != id && state != "crash" && target_z > 0)  {
		z = 0;
		target_z = 0;
		do_crash();
	}
}
// Add To Top Of Stack
else if (obj_cursor.selected_object != id && state != "crash" && abs(z - target_z) <= 1 && target_z >= -UNIT_SIZE * ds_list_size(GRID_CRASHES[# u, v]) * 0.5)
	do_crash();
	
// Spew Fire If Top Of Crash Pile
if (state == "crash" && SLOW_FACTOR != 0) {
	var _list = GRID_CRASHES[# u, v];
	var _size = ds_list_size(_list);
	if (_list[| _size - 1] == id && _list[| 0] != id)
		fire_particle_create(x, y, z);
}

// Offset Z Position To Account For Bottom Model Origin
if (obj_cursor.selected_object != id && state == "crash") {
	var _dif	 = abs(180 - model.xangle);
	var _percent = _dif / 180;
	model.z		-= UNIT_SIZE * _percent * 0.3;
}

// Wood Particles
if (alarm0 != -1 && SLOW_FACTOR != 0) {
	if (irandom(1) == 0)
		wood_particle_create(x, y);
}