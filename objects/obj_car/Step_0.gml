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
if (state != "crash" && abs(x - target_x) <= 0.2 && abs(y - target_y) <= 0.2) {
	var _car = collision_circle(x, y, 5, obj_car, false, true);
	if (_car != undefined && _car != noone)
		do_crash();
}

// Spew Fire If Top Of Crash Pile
if (state == "crash" && SLOW_FACTOR != 0) {
	var _list = GRID_CRASHES[# u, v];
	var _size = ds_list_size(_list);
	if (_list[| _size - 1] == id)
		fire_particle_create(x, y, -_size * UNIT_SIZE * 0.5);
}

// Offset Z Position To Account For Bottom Model Origin
var _dif	 = abs(180 - model.xangle);
var _percent = _dif / 180;
model.z		-= UNIT_SIZE * _percent * 0.5;