if (alarm0 == -1 && !dead) {
	var _car	 = collision_circle(x, y, 1, obj_car, false, false);
	var _car_hit = (_car != noone && _car != undefined && _car != obj_cursor.selected_object && _car.state != "ascend" && _car.state != "descend");
	var _piano	 = collision_circle(x, y, 1, obj_piano, false, false);
	var _piano_hit = (_piano != noone && _piano != undefined && _piano != obj_cursor.selected_object && _piano.state == "crash");
	
	if  (_car_hit || _piano_hit) {
		alarm0 = 60;
		dead = true;
		music_set(1);
		sprite_index = spr_characters_dead_bottom;
		top_x = random_range(-UNIT_SIZE * 0.5, UNIT_SIZE * 0.5);
		top_y = random_range(-UNIT_SIZE * 0.5, UNIT_SIZE * 0.5);
		audio_play_sound(choose(sfx_scream_1, sfx_scream_2, sfx_scream_3, sfx_scream_4, sfx_scream_5, sfx_scream_6), 0, false);
		audio_play_sound(ssfx_splurt, 0, false);
	}
}

if (dead && alarm0 != -1 && SLOW_FACTOR != 0)
	blood_particle_create(x, y);
if (!grid_in_bounds(GRID_CHARS, u, v))
	instance_destroy();