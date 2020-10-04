event_inherited();
model.x = x;
model.y = y;
model.z = z;
model.update();
show	= grid_in_bounds(GRID_CARS, u, v);

// Face Way Driving
if (state != "crash") {
	switch (facing) {
		case DIR.RIGHT:	model.zangle = 180;	break;
		case DIR.LEFT:	model.zangle = 0;	break;
		case DIR.UP:	model.zangle = 270;	break;
		case DIR.DOWN:	model.zangle = 90;	break;
	}
}
	
// Check For Car Crash After Completed Moving
if (state != "crash" && abs(x - target_x) <= 1 && abs(y - target_y) <= 1) {
	var _car = collision_circle(x, y, 5, obj_car, false, true);
	if (_car != undefined && _car != noone)
		do_crash();
	var _piano = collision_circle(x, y, 5, obj_piano, false, false);
	if (_piano != undefined && _piano != noone) {
		if (abs(_piano.z - z) <= UNIT_SIZE * 0.25) {
			do_crash();
			
			if (_piano.state != "crash")
				_piano.do_crash();
		}
	}
}

// Spew Fire If Top Of Crash Pile
if (state == "crash" && SLOW_FACTOR != 0) {
	var _list = GRID_CRASHES[# u, v];
	var _size = ds_list_size(_list);
	if (_list[| _size - 1] == id)
		fire_particle_create(x, y, z);
}

// Ramp Ascend & Ramp Crash
if (state != "crash" && state != "ascend" && abs(x - target_x) <= 1 && abs(y - target_y) <= 1) {
	var _ramp = collision_circle(x, y, 5, obj_ramp, false, false);
	if (_ramp != noone && _ramp != undefined) {
		var _sideways = (
			(_ramp.facing == DIR.RIGHT	&& facing != DIR.RIGHT)	||
			(_ramp.facing == DIR.LEFT	&& facing != DIR.LEFT)	||
			(_ramp.facing == DIR.UP		&& facing != DIR.UP)	||
			(_ramp.facing == DIR.DOWN	&& facing != DIR.DOWN)
		);
		
		// Ascend
		if (!_sideways) {
			target_z = _ramp.z - UNIT_SIZE * 0.5;
			model.zangle_target = 45;
			state	 = "ascend";
			action	 = ascend;
			hangtime = clamp(0, momentum - 1, 10);
		}
		// Crash
		else if (abs(_ramp.z - z) <= UNIT_SIZE * 0.25) {
			if (_ramp.state != "crash")
				_ramp.do_crash();
			do_crash();
		}
	}
}

// Offset Z Position To Account For Bottom Model Origin
if (state == "crash") {
	var _dif	 = abs(180 - model.xangle);
	var _percent = _dif / 180;
	model.z		-= UNIT_SIZE * _percent * 0.5;
}