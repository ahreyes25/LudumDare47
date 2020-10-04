event_inherited();

model.x = x;
model.y = y;
model.z = z;
model.update();

// Check For Crashes When There Are No Crashes Below Us
if (GRID_CRASHES[# u, v] == undefined) {
	var _car = collision_circle(x, y, 5, obj_car, false, true);
	if (_car != undefined && _car != noone) {
		if (state != "crash" && abs(z - target_z) <= 1 && z >= -UNIT_SIZE) {
			_car.do_crash();
			do_crash();
		}
	}
	// Check For Ground
	else if (state != "crash" && abs(z - target_z) <= 1 && z >= -UNIT_SIZE * 0.5)
		do_crash();
}
// Add To Top Of Stack
else if (state != "crash" && abs(z - target_z) <= 1 && z >= -UNIT_SIZE * ds_list_size(GRID_CRASHES[# u, v]))
	do_crash();
	

// Spew Fire If Top Of Crash Pile
if (state == "crash" && SLOW_FACTOR != 0) {
	var _list = GRID_CRASHES[# u, v];
	var _size = ds_list_size(_list);
	if (_list[| _size - 1] == id && _list[| 0] != id)
		fire_particle_create(x, y, -_size * UNIT_SIZE * 0.5);
}

// Offset Z Position To Account For Bottom Model Origin
var _dif	 = abs(180 - model.xangle);
var _percent = _dif / 180;
model.z		-= UNIT_SIZE * _percent * 0.5;