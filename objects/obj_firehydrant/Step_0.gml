if (busted && SLOW_FACTOR != 0)
	water_particle_create(x, y);

var _car = collision_circle(x, y, 1, obj_car, false, false);
if (_car != noone && _car != undefined && _car != obj_cursor.selected_object)
	busted = true;