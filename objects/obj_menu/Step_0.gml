if (keyboard_check_pressed(vk_enter)) {
	obj_game.in_main_menu = false;
	obj_camera.panning = false;	
	cleared_game = false;
}
if (keyboard_check_pressed(vk_escape)) {
	obj_game.in_main_menu = true;
	obj_camera.panning = true;
}

if (keyboard_check_pressed(ord("R")) && obj_game.in_main_menu) {
	ds_list_clear(obj_game.player_actions);
	obj_game.round_counter = 0;
	obj_game.turn_counter = 0;
	room_restart();
	cleared_game = true;
}