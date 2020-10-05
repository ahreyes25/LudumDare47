event_inherited();

model.x = x;
model.y = y;
model.z = z;
model.update();

// Check For Crashes When There Are No Crashes Below Us
if (GRID_CRASHES[# u, v] == undefined) {		
	// Check For Ramps and Cars
	if (state != "crash" && abs(z - target_z) <= 1 && target_z >= -UNIT_SIZE * 0.5) {
		var _car = collision_circle(x, y, 5, obj_car, false, true);
		if (_car != undefined && _car != noone) {
			if (_car.state != "crash")
				_car.do_crash();
			do_crash();
		}
		else {
			var _ramp = collision_circle(target_x, target_y, 5, obj_ramp, false, true);
			if (_ramp != undefined && _ramp != noone) {
				if (_ramp.state != "crash")
					_ramp.do_crash();
				do_crash();
			}
		}
	}
	// Check For Ground
	if (state != "crash" && target_z > 0)  {
		z = 0;
		target_z = 0;
		do_crash();
	}
}
// Add To Top Of Stack
else if (state != "crash" && abs(z - target_z) <= 1 && target_z >= -UNIT_SIZE * ds_list_size(GRID_CRASHES[# u, v]) * 0.5)
	do_crash();
	
// Spew Fire If Top Of Crash Pile
if (state == "crash" && SLOW_FACTOR != 0) {
	var _list = GRID_CRASHES[# u, v];
	var _size = ds_list_size(_list);
	if (_list[| _size - 1] == id && _list[| 0] != id)
		fire_particle_create(x, y, z);
}

// Offset Z Position To Account For Bottom Model Origin
var _dif	 = abs(180 - model.xangle);
var _percent = _dif / 180;
model.z		-= UNIT_SIZE * _percent * 0.3;

// Wood Particles
if (alarm0 != -1 && SLOW_FACTOR != 0) {
	if (irandom(1) == 0)
		wood_particle_create(x, y);
}