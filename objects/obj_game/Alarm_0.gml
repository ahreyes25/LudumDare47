/// @description Execute ACTIONS!

if (execute || placed_item_this_round) {
	obj_grid.act_on_entities();
	turn_counter++;
	recreate_actions();
}