switch (room) {
	case rm_main:
		instance_create_depth(0, 0, depth, obj_ground_test);
		recreate_actions();
		break;
}
music_set(0);

if (game_won) {
	ds_list_clear(player_actions);
	round_counter = 0;
	turn_counter = 0;
	obj_game.in_main_menu = true;
	objectives_index = 0;
}