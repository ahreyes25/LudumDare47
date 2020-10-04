event_inherited();

model.x = x;
model.y = y;
model.z = z;

if (state != "crash" && abs(z - target_z) <= 0.1 && z >= -UNIT_SIZE) {
	var _car = collision_circle(x, y, 5, obj_car, false, true);
	if (_car != undefined && _car != noone) {
		_car.do_crash();
		do_crash();
	}
}

// Spew Fire If Top Of Crash Pile
if (state == "crash" && SLOW_FACTOR != 0) {
	var _list = GRID_CRASHES[# u, v];
	var _size = ds_list_size(_list);
	if (_list[| _size - 1] == id)
		fire_particle_create(x, y, -_size * UNIT_SIZE * 0.5);
}
