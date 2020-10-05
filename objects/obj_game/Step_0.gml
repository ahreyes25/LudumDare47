if (instance_exists(obj_grid) && !instance_exists(obj_camera))
	instance_create_depth(x, y, depth, obj_camera);
depth = obj_camera.depth + 1;	

SLOW_FACTOR = execute;

// Game Logic
if (!in_main_menu) {
	if (alarm[0] == -1 && turn_counter < turns_total)
		alarm[0] = frames_per_turn;
}

if (keyboard_check_pressed(vk_space)) {
	obj_grid.act_on_entities();
	turn_counter++;
	alarm[0] = frames_per_turn;
	execute = true;  
}
if (keyboard_check_released(vk_space)) {
	execute = false;
	alarm[0] = -1;
}
if (turn_counter >= turns_total) {
	execute = false;
	alarm[0] = -1;
}