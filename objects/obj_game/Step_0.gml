if (live_call()) return live_result;

if (instance_exists(obj_grid) && !instance_exists(obj_camera))
	instance_create_depth(x, y, depth, obj_camera);
depth = obj_camera.depth + 1;	

SLOW_FACTOR = execute;

// Game Logic
if (!in_main_menu) {
	if (alarm[0] == -1 && turn_counter < turns_total)
		alarm[0] = frames_per_turn;
}

#region Space To Advance Game
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
#endregion
#region Mouse Click To Select Inventory Item
var _scale			= 4;
var _frame_width	= sprite_get_width(spr_frame)  * _scale;
var _frame_height	= sprite_get_height(spr_frame) * _scale;
var _x_start		= SW * 0.5 - _frame_width * (inventory_size / 2) + _frame_width * 0.5;
var _x_left			= _x_start - _frame_width / 2;
var _x_right		= _x_start + inventory_size * _frame_width - _frame_width * 0.5;
var _y_bot			= inventory_y + _frame_height;
var _y_top			= inventory_y;
var _mxg			= device_mouse_x_to_gui(0);
var _myg			= device_mouse_y_to_gui(0);

// If Mouse Over Inventory
if (_mxg >= _x_left && _mxg <= _x_right && _myg >= _y_top && _myg <= _y_bot) {
	var _cell_i = (_mxg - _x_left) div _frame_width;
	if (!placed_item_this_round && device_mouse_check_button_pressed(0, mb_left)) {
		obj_cursor.clear_selected();
		obj_cursor.center();
		
		// Havent Placed This Item This Round
		if (!inventory[_cell_i][1]) {
			var _object		= inventory[_cell_i][0];
			var _instance	= instance_create_depth(obj_cursor.x, obj_cursor.y, depth, _object);
			obj_cursor.selected_object = _instance;
			obj_cursor.center();
		}
	}
}

// Mouse Over Inventory Tab Toggle
var _tab_x_left	 = _x_start + ((inventory_size / 2) - 1) * _frame_width;
var _tab_x_right = _tab_x_left + sprite_get_width(spr_inventory_tab) * _scale;
var _tab_y_bot	 = SH - _frame_height * inventory_show;
var _tab_y_top	 = _tab_y_bot - sprite_get_height(spr_inventory_tab) * _scale;
if (_mxg >= _tab_x_left && _mxg <= _tab_x_right && _myg >= _tab_y_top && _myg <= _tab_y_bot) {
	if (device_mouse_check_button_pressed(0, mb_left))
		inventory_show = !inventory_show;
}	
#endregion

inventory_y_target = SH - _frame_height * inventory_show;
inventory_y = lerp(inventory_y, inventory_y_target, 0.1);











