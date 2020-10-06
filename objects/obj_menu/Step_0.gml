if (keyboard_check_pressed(vk_f1))
	show_controls = !show_controls;

if (keyboard_check_pressed(vk_space) && (show_controls || obj_game.in_main_menu)) {
	obj_game.in_main_menu = false;
	obj_camera.panning = false;	
	cleared_game = false;
	obj_game.alarm[5] = 10;
	
	if (!showed_controls) {
		show_controls = true;
		showed_controls = true;
	}
	else 
		show_controls = false;
}
if (keyboard_check_pressed(vk_escape)) {
	if (!show_controls) {
		obj_game.in_main_menu = true;
		obj_camera.panning = true;
		show_controls = false;
	}
	else
		show_controls = false;
}

if (keyboard_check_pressed(ord("R")) && obj_game.in_main_menu) {
	ds_list_clear(obj_game.player_actions);
	obj_game.round_counter = 0;
	obj_game.turn_counter = 0;
	room_restart();
	cleared_game = true;
	obj_game.objectives_index = 0;
}