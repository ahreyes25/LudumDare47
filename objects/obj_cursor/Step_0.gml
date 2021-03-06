if (selected_object != undefined) {
	if (selected_object.object_index == obj_piano)
		ztarget = selected_object.z;
	else
		ztarget = z_base;
}
show = selected_object != undefined;

x = lerp(x, xtarget, 0.1);
y = lerp(y, ytarget, 0.1);
z = lerp(z, ztarget, 0.1);

var _left_pressed	= !keyboard_check(vk_shift) && keyboard_check_pressed(ord("A"));
var _right_pressed	= !keyboard_check(vk_shift) && keyboard_check_pressed(ord("D"));
var _up_pressed		= !keyboard_check(vk_shift) && keyboard_check_pressed(ord("W"));
var _down_pressed	= !keyboard_check(vk_shift) && keyboard_check_pressed(ord("S"));

if (obj_camera.position_index <= 1) {
	if (_left_pressed)	move(1, DIR.UP);
	if (_right_pressed) move(1, DIR.DOWN);
	if (_up_pressed)	move(1, DIR.RIGHT);
	if (_down_pressed)	move(1, DIR.LEFT);
}
else if (obj_camera.position_index >= array_length(obj_camera.positions) - 2) {
	if (_left_pressed)	move(1, DIR.DOWN);
	if (_right_pressed) move(1, DIR.UP);
	if (_up_pressed)	move(1, DIR.LEFT);
	if (_down_pressed)	move(1, DIR.RIGHT);
}
else {
	if (_left_pressed)	move(1, DIR.LEFT);
	if (_right_pressed) move(1, DIR.RIGHT);
	if (_up_pressed)	move(1, DIR.UP);
	if (_down_pressed)	move(1, DIR.DOWN);
}
	
// Rotate Selected Item
if (selected_object != undefined) {
	if (keyboard_check_pressed(ord("E"))) {
		switch (selected_object.facing) {
			case DIR.RIGHT:	selected_object.facing = DIR.DOWN;	break;	
			case DIR.LEFT:	selected_object.facing = DIR.UP;	break;	
			case DIR.UP:	selected_object.facing = DIR.RIGHT; break;	
			case DIR.DOWN:	selected_object.facing = DIR.LEFT;	break;	
		}
	}
	else if (keyboard_check_pressed(ord("Q"))) {
		switch (selected_object.facing) {
			case DIR.RIGHT:	selected_object.facing = DIR.UP;	break;	
			case DIR.LEFT:	selected_object.facing = DIR.DOWN;	break;	
			case DIR.UP:	selected_object.facing = DIR.LEFT;	break;	
			case DIR.DOWN:	selected_object.facing = DIR.RIGHT;	break;	
		}
	}
}

// Place Selected Object Into World
if (selected_object != undefined && keyboard_check_pressed(ord("F"))) {
	// Check That Item Doesnt Already Exist There
	var _coords = grid_to_world(u, v);
	var _x		= _coords[0] + UNIT_SIZE * 0.5;
	var _y		= _coords[1] + UNIT_SIZE * 0.5;
	
	switch (selected_object.object_index) {
		case obj_car:	
			var _list	= ds_list_create();
			var _count	= collision_circle_list(_x, _y, 5, obj_car, false, false, _list, false);	
			var _pass	= true;
			
			if (_count > 1) {
				_pass = true;
				for (var i = 0; i < _count; i++) {
					var _inst	= _list[| i];	
					if (_inst == obj_cursor.selected_object)
						continue;
					var _in_air = (_inst.state == "ascend" || _inst.state == "descend");
					if (!_in_air) {
						_pass = false;
						break;
					}
				}
			}
			
			ds_list_clear(_list);
			var _char_count = collision_circle_list(_x, _y, 5, obj_char, false, false, _list, false);
			if (_char_count > 0)
				_pass = false;
			ds_list_destroy(_list);
			break;
			
		case obj_ramp:	
			var _pass = (GRID_CARS[# u, v] == grid_get_empty_value(ENTITY.CAR));
			break;
			
		case obj_cone:	
			var _pass = (GRID_CONES[# u, v] == grid_get_empty_value(ENTITY.CONE));
			break;
			
		case obj_piano:	
			var _list	= ds_list_create();
			var _count	= collision_circle_list(_x, _y, 5, obj_piano, false, false, _list, false);	
			var _pass	= true;
			
			if (_count > 1) {
				for (var i = 0; i < _count; i++) {
					var _inst	= _list[| i];	
					if (_inst == obj_cursor.selected_object)
						continue;
					var _below	= (_inst.z > -3 * UNIT_SIZE);	// check against default piano spawn height
					if (!_below) {
						_pass = false;
						break;
					}
				}
			}
			
			ds_list_clear(_list);
			var _char_count = collision_circle_list(_x, _y, 5, obj_char, false, false, _list, false);
			if (_char_count > 0)
				_pass = false;
			
			ds_list_destroy(_list);
			break;
	}

	if (_pass) {
		// Save Action For Replay Later
		var _action = [
			obj_game.turn_counter,
			selected_object.object_index,
			selected_object.u,
			selected_object.v,
			selected_object.x,
			selected_object.y,
			selected_object.z,
			obj_game.round_counter,
			selected_object.facing,
		];
		ds_list_add(obj_game.player_actions, _action);
		
		
		if (selected_object.object_index == obj_car)
			selected_object.editing = false;
		else if (selected_object.object_index == obj_ramp)
			selected_object.moving = false;
		else if (selected_object.object_index == obj_cone)
			selected_object.moving = false;
			
		selected_object = undefined;	
		obj_cursor.show = false;
		obj_game.placed_item_this_round = true;
		obj_game.inventory_show = false;
		audio_play_sound(sfx_unpause, 0, 0);
	}
	else
		audio_play_sound(sfx_fail, 0, 0);
}
else if (selected_object == undefined && keyboard_check_pressed(ord("F")))
	obj_game.inventory_show = !obj_game.inventory_show;

depth = obj_camera.depth - 1;

if (keyboard_check_pressed(vk_numpad0))
	obj_game.placed_item_this_round = false;






























