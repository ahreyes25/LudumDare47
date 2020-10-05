// Draw In Game GUI
if (!obj_game.in_main_menu) {
	var _scale			= 4;
	var _round_width	= sprite_get_width(spr_round) * _scale;
	var _round_height	= sprite_get_height(spr_round) * _scale;
	var _turn_width		= sprite_get_width(spr_turn) * _scale;
	var _turn_height	= sprite_get_height(spr_turn) * _scale;
	var _numbers_width	= sprite_get_width(spr_numbers) * _scale;
	var _numbers_height = sprite_get_height(spr_numbers) * _scale;
	var _colon_width	= sprite_get_width(spr_colon) * _scale;
	var _colon_height	= sprite_get_height(spr_colon) * _scale;
	var _slash_width	= sprite_get_width(spr_slash) * _scale;
	var _slash_height	= sprite_get_height(spr_slash) * _scale;
	
	var _round_x = 30;
	var _round_y = 30;
	var _turn_x  = 30;
	var _turn_y  = 100;
	
	#region Rounds
	draw_sprite_ext(spr_round, 0, _round_x, _round_y, _scale, _scale, 0, c_white, 1);
	draw_sprite_ext(spr_colon, 0, _round_x + _round_width + _colon_width * 0.5, _round_y + _colon_height * 0.5, _scale, _scale, 0, c_white, 1);

	// Draw Rounds Counter
	if (obj_game.round_counter < 100) {
		var _shift = obj_game.round_counter >= 10;
		if (obj_game.round_counter >= 10) {
			var _left_digit = (obj_game.round_counter div 10);
			draw_sprite_ext(spr_numbers, _left_digit, _round_x + _round_width + _colon_width * 2, _round_y + _numbers_height / 2, _scale, _scale, 0, c_white, 1);
		}
		else 
			draw_sprite_ext(spr_numbers, obj_game.round_counter, _round_x + _round_width + _colon_width * 2, _round_y + _numbers_height / 2, _scale, _scale, 0, c_white, 1);
		if (obj_game.round_counter >= 10) {
			var _right_digit = (obj_game.round_counter mod 10);
			draw_sprite_ext(spr_numbers, _right_digit, _round_x + _round_width + _colon_width * 2 + _numbers_width, _round_y + _numbers_height / 2, _scale, _scale, 0, c_white, 1);
		}
	}
	else
		draw_sprite_ext(spr_infinity, obj_game.round_counter, _round_x + _round_width + _colon_width * 2, _round_y + _numbers_height / 2, _scale, _scale, 0, c_white, 1);

	// Slash
	draw_sprite_ext(spr_slash, 0, _round_x + _round_width + _colon_width * 2 + _numbers_width + _numbers_width * _shift, _round_y + _slash_height * 0.5, _scale, _scale, 0, c_white, 1);	
	
	// Draw Rounds Total
	draw_sprite_ext(spr_infinity, 0, _round_x + _round_width + _colon_width * 2 + _numbers_width * 2 + _numbers_width * _shift, _round_y + _slash_height * 0.5, _scale, _scale, 0, c_white, 1);
	//if (obj_game.rounds_total >= 10) {
	//	var _left_digit = (obj_game.rounds_total div 10);
	//	draw_sprite_ext(spr_numbers, _left_digit, _round_x + _round_width + _colon_width * 2 + _numbers_width * 2 + _numbers_width * _shift, _round_y + _slash_height * 0.5, _scale, _scale, 0, c_white, 1);
	//}
	//else 
	//	draw_sprite_ext(spr_numbers, obj_game.rounds_total, _round_x + _round_width + _colon_width * 2 + _numbers_width * 2 + _numbers_width * _shift, _round_y + _slash_height * 0.5, _scale, _scale, 0, c_white, 1);
	//if (obj_game.rounds_total >= 10) {
	//	var _right_digit = (obj_game.rounds_total mod 10);
	//	draw_sprite_ext(spr_numbers, _right_digit, _round_x + _round_width + _colon_width * 2 + _numbers_width * 3 + _numbers_width * _shift, _round_y + _slash_height * 0.5, _scale, _scale, 0, c_white, 1);
	//}
	#endregion
	#region Turns
	draw_sprite_ext(spr_turn, 0, _turn_x, _turn_y, _scale, _scale, 0, c_white, 1);
	draw_sprite_ext(spr_colon, 0, _turn_x + _turn_width + _colon_width * 0.5, _turn_y + _colon_height * 0.5, _scale, _scale, 0, c_white, 1);
		
	// Draw Rounds Counter
	var _shift = obj_game.turn_counter >= 10;
	if (obj_game.turn_counter >= 10) {
		var _left_digit = (obj_game.turn_counter div 10);
		draw_sprite_ext(spr_numbers, _left_digit, _turn_x + _turn_width + _colon_width * 2, _turn_y + _numbers_height / 2, _scale, _scale, 0, c_white, 1);
	}
	else 
		draw_sprite_ext(spr_numbers, obj_game.turn_counter, _turn_x + _turn_width + _colon_width * 2, _turn_y + _numbers_height / 2, _scale, _scale, 0, c_white, 1);
	if (obj_game.turn_counter >= 10) {
		var _right_digit = (obj_game.turn_counter mod 10);
		draw_sprite_ext(spr_numbers, _right_digit, _turn_x + _turn_width + _colon_width * 2 + _numbers_width, _turn_y + _numbers_height / 2, _scale, _scale, 0, c_white, 1);
	}

	// Slash
	draw_sprite_ext(spr_slash, 0, _turn_x + _turn_width + _colon_width * 2 + _numbers_width + _numbers_width * _shift, _turn_y + _slash_height * 0.5, _scale, _scale, 0, c_white, 1);	
	
	// Draw turns Total
	if (obj_game.turns_total >= 10) {
		var _left_digit = (obj_game.turns_total div 10);
		draw_sprite_ext(spr_numbers, _left_digit, _turn_x + _turn_width + _colon_width * 2 + _numbers_width * 2 + _numbers_width * _shift, _turn_y + _slash_height * 0.5, _scale, _scale, 0, c_white, 1);
	}
	else 
		draw_sprite_ext(spr_numbers, obj_game.turns_total, _turn_x + _turn_width + _colon_width * 2 + _numbers_width * 2 + _numbers_width * _shift, _turn_y + _slash_height * 0.5, _scale, _scale, 0, c_white, 1);
	if (obj_game.turns_total >= 10) {
		var _right_digit = (obj_game.turns_total mod 10);
		draw_sprite_ext(spr_numbers, _right_digit, _turn_x + _turn_width + _colon_width * 2 + _numbers_width * 3 + _numbers_width * _shift, _turn_y + _slash_height * 0.5, _scale, _scale, 0, c_white, 1);
	}
	#endregion
	
	// Draw Inventory
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	draw_set_color(c_black);
	var _frame_width	= sprite_get_width(spr_frame) * _scale;
	var _frame_height	= sprite_get_height(spr_frame) * _scale;
	var _xstart			= SW * 0.5 - (_frame_width * (array_length(obj_game.inventory) / 2)) + _frame_width * 0.5;

	// Draw Inventory Tab
	draw_sprite_ext(spr_inventory_tab, !obj_game.inventory_show, _xstart + array_length(obj_game.inventory) * 0.5 * _frame_width - _frame_width / 2, obj_game.inventory_y + 4, _scale, _scale, 0, c_white, 1);

	// Draw Inventory Slots
	for (var i = 0; i < array_length(obj_game.inventory); i++) {
		draw_sprite_ext(spr_frame, 0, _xstart + (i * _frame_width), obj_game.inventory_y + _frame_height, _scale, _scale, 0, c_white, 1);
		
		var _object = obj_game.inventory[i];
		draw_text(_xstart + (i * _frame_width), obj_game.inventory_y + _frame_height - _frame_height * 0.5, object_get_name(_object));
	}
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
}
// Draw Main Menu