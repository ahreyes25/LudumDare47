if (instance_exists(obj_grid) && !instance_exists(obj_camera))
	instance_create_depth(x, y, depth, obj_camera);
	
SLOW_FACTOR = !keyboard_check(ord("U"));

depth = obj_camera.depth + 1;



// Game Logic
if (!in_main_menu) {
	if (alarm[0] == -1 && turn_counter < turns_total)
		alarm[0] = frames_per_turn;
}

if (keyboard_check_pressed(vk_space))
	execute = !execute;