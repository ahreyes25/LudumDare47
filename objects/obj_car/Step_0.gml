event_inherited();

if (instance_exists(obj_camera))
	depth = obj_camera.depth - 1;

if (editing) {
	switch (facing) {
		case DIR.LEFT:	model.zangle = 0;	model.zangle_target = 0;	break;	
		case DIR.RIGHT:	model.zangle = 180;	model.zangle_target = 180;	break;	
		case DIR.UP:	model.zangle = 270;	model.zangle_target = 270;	break;	
		case DIR.DOWN:	model.zangle = 90;	model.zangle_target = 90;	break;	
	}	
}

model.x = x;
model.y = y;
model.z = z;
model.update();
show = grid_in_bounds(GRID_CARS, u, v);

// Face Way Driving
if (obj_cursor.selected_object != id && state != "crash") {
	switch (facing) {
		case DIR.RIGHT:	model.zangle = 180;	break;
		case DIR.LEFT:	model.zangle = 0;	break;
		case DIR.UP:	model.zangle = 270;	break;
		case DIR.DOWN:	model.zangle = 90;	break;
	}
}
	
// Check For Car Crash After Completed Moving
if (obj_cursor.selected_object != id && state != "crash" && abs(x - target_x) <= 1 && abs(y - target_y) <= 1) {
	// Check For Crash Against Stack Of Cars
	if (state == "ascend" || state == "descend") {
		var _list = GRID_CRASHES[# u, v];
		if (_list != undefined) {
			if (target_z >= -ds_list_size(_list) * UNIT_SIZE * 0.5)
				do_crash();
		}
	}
	// Check For Crash Against Grounded Cars
	else if (state != "crash") {
		var _car = collision_circle(target_x, target_y, 5, obj_car, false, true);
		if (_car != undefined && _car != noone && _car.z >= -0.1 && obj_cursor.selected_object != _car)
			do_crash();
	}
		
	// Crash Against Piano
	if (state != "crash") {
		var _piano = collision_circle(target_x, target_y, 5, obj_piano, false, false);
		if (obj_cursor.selected_object != _piano && _piano != undefined && _piano != noone) {
			if (abs(_piano.z - target_z) <= UNIT_SIZE * 0.25) {
				do_crash();
			
				if (_piano.state != "crash")
					_piano.do_crash();
			}
		}
	}
}

// Spew Fire If Top Of Crash Pile
if (obj_cursor.selected_object != id && state == "crash" && SLOW_FACTOR != 0) {
	var _list = GRID_CRASHES[# u, v];
	if (_list != undefined) {
		var _size = ds_list_size(_list);
		if (_list[| _size - 1] == id)
			fire_particle_create(x, y, z);
	}
}

// Ramp Ascend & Ramp Crash
if (obj_cursor.selected_object != id && state != "crash" && state != "ascend" && abs(x - target_x) <= 1 && abs(y - target_y) <= 1) {
	var _ramp = collision_circle(target_x, target_y, 5, obj_ramp, false, false);
	if (_ramp != noone && _ramp != undefined) {
		var _sideways = (
			(_ramp.facing == DIR.RIGHT	&& facing != DIR.RIGHT)	||
			(_ramp.facing == DIR.LEFT	&& facing != DIR.LEFT)	||
			(_ramp.facing == DIR.UP		&& facing != DIR.UP)	||
			(_ramp.facing == DIR.DOWN	&& facing != DIR.DOWN)
		);
		
		// Ascend
		if (!_sideways && obj_cursor.selected_object != _ramp) {
			target_z = _ramp.z - UNIT_SIZE * 0.5;
			model.zangle_target = 45;
			state	 = "ascend";
			action	 = ascend;
			hangtime = momentum;
		}
		// Crash
		else if (obj_cursor.selected_object != _ramp && obj_cursor.selected_object != id && abs(_ramp.target_z - target_z) <= UNIT_SIZE * 0.25) {
			if (_ramp.state != "crash" && obj_cursor.selected_object != _ramp)
				_ramp.do_crash();
			do_crash();
		}
	}
}

// Offset Z Position To Account For Bottom Model Origin
if (obj_cursor.selected_object != id && state == "crash") {
	var _dif	 = abs(180 - model.xangle);
	var _percent = _dif / 180;
	model.z		-= UNIT_SIZE * _percent * 0.5;
}
	
// Crash Into Building
if (state != "crash" && obj_cursor.selected_object != id && !off) {
	var _coords = world_to_grid(target_x, target_y);
	var _u		= _coords[0];
	var _v		= _coords[1];
	
	if (GRID_ENVIRONMENT[# _u, _v] == ENVIRONMENT.BUILDING) {
		target_x = x;
		target_y = y;
		target_z = z;
	
		switch (facing) {
			case DIR.RIGHT:	u = _u - 1;	break;	
			case DIR.LEFT:	u = _u + 1;	break;
			case DIR.UP:	v = _v + 1;	break;	
			case DIR.DOWN:	v = _v - 1;	break;	
		}
		do_crash();
	}
}