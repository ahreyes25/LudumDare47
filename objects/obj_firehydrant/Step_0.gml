if (busted && SLOW_FACTOR != 0)
	water_particle_create(x, y);

var _car = collision_circle(x, y, 1, obj_car, false, false);
if (!busted && _car != noone && _car != undefined && _car != obj_cursor.selected_object && _car.state != "ascend" && _car.state != "descend") {
	busted = true;
	audio_play_sound(sfx_noise, 0, 0);
}