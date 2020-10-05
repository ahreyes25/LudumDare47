if (alarm0 == -1 && !dead) {
	var _car = collision_circle(x, y, 1, obj_car, false, false);
	if (_car != noone && _car != undefined && _car != obj_cursor.selected_object) {
		alarm0 = 60;
		dead = true;
		music_set(1);
		sprite_index = spr_characters_dead_bottom;
		top_x = random_range(-UNIT_SIZE * 0.5, UNIT_SIZE * 0.5);
		top_y = random_range(-UNIT_SIZE * 0.5, UNIT_SIZE * 0.5);
	}
}

if (dead && alarm0 != -1 && SLOW_FACTOR != 0)
	blood_particle_create(x, y);