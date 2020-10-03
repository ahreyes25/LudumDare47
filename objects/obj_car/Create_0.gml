event_inherited();

entity			= ENTITY.CAR;
action			= undefined;
max_momentum	= 2;
momentum		= max_momentum;
move_speed		= 1;
action			= undefined;
state			= "drive";
list			= ds_list_create();

update_uvs();
store_in_grid();

get_stoplight	= function(_dir, _dist) {
	switch (_dir) {
		case DIR.RIGHT:	return collision_line(x, y, x + UNIT_SIZE * _dist, y, obj_stoplight, false, false);	break;
		case DIR.LEFT:	return collision_line(x, y, x - UNIT_SIZE * _dist, y, obj_stoplight, false, false);	break;
		case DIR.UP:	return collision_line(x, y, x, y - UNIT_SIZE * _dist, obj_stoplight, false, false);	break;
		case DIR.DOWN:	return collision_line(x, y, x, y + UNIT_SIZE * _dist, obj_stoplight, false, false);	break;
	}
}
get_car			= function(_dir, _dist) {
	switch (_dir) {
		case DIR.RIGHT:	return collision_line(x, y, x + UNIT_SIZE * _dist, y, obj_car, false, true);	break;
		case DIR.LEFT:	return collision_line(x, y, x - UNIT_SIZE * _dist, y, obj_car, false, true);	break;
		case DIR.UP:	return collision_line(x, y, x, y - UNIT_SIZE * _dist, obj_car, false, true);	break;
		case DIR.DOWN:	return collision_line(x, y, x, y + UNIT_SIZE * _dist, obj_car, false, true);	break;
	}
}
check_for_brake	= function() {
	// Check For Cars To Start Braking
	ds_list_clear(list);
	var _car_coords = grid_check_for(ENTITY.CAR, u, v, facing, momentum + 1);
	if (_car_coords[0] != undefined && _car_coords[1] != undefined) {
		grid_get_instances_at(ENTITY.CAR, _car_coords[0], _car_coords[1], list, true);
		var _car = list[| 0];
		
		if (_car != noone && _car != undefined && (_car.state == "brake" || _car.state == "idle"))  {
			action = brake;
			state  = "brake";
		}
	}
	
	// Check For Stoplights To Start Braking
	if (state != "brake") {
		ds_list_clear(list);
		var _stoplight_coords = grid_check_for(ENTITY.STOPLIGHT, u, v, facing, momentum + 1);
		if (_stoplight_coords[0] != undefined && _stoplight_coords[1] != undefined) {
			grid_get_instances_at(ENTITY.STOPLIGHT, _stoplight_coords[0], _stoplight_coords[1], list, true);
			var _stoplight = list[| 0];

			if (_stoplight != noone && _stoplight != undefined) {
				var _stoplight_coords	= world_to_grid(_stoplight.x, _stoplight.y);
				var _stoplight_u		= _stoplight_coords[0];
				var _stoplight_v		= _stoplight_coords[1];
				var _dist				= abs(u - _stoplight_u);
	
				if (u != _stoplight_u && _stoplight.light == "red")  {
					action = brake;
					state  = "brake";
				}
				else if (u != _stoplight_u && _stoplight.light == "yellow") {
					switch (facing) {
						case DIR.RIGHT:
							if (u < _stoplight_u && _dist - 1 >= momentum && _stoplight.light_count <= momentum) {
								action = brake;
								state  = "brake";
							}
							break;
							
						case DIR.LEFT:
							if (u > _stoplight_u && _dist - 1 >= momentum && _stoplight.light_count <= momentum) {
								action = brake;
								state  = "brake";
							}
							break;
							
						case DIR.DOWN:
							if (v < _stoplight_u && _dist - 1 >= momentum && _stoplight.light_count <= momentum) {
								action = brake;
								state  = "brake";
							}
							break;
							
						case DIR.UP:
							if (v > _stoplight_v && _dist - 1 >= momentum && _stoplight.light_count <= momentum) {
								action = brake;
								state  = "brake";
							}
							break;
					}
				}
			}	
		}
	}
}
adjacent_free	= function(_dir) {
	switch (_dir) {
		case DIR.RIGHT:		
			var _car		= collision_line(x, y, x + UNIT_SIZE, y, obj_car, false, true);
			var _stoplight	= collision_line(x, y, x + UNIT_SIZE, y, obj_stoplight, false, false);
			break;
	}
	var _open = (
		_car == noone && 
		(_stoplight == noone || _stoplight.light != "red")
	);
	return _open;
}

drive	= function() {
	if (momentum < max_momentum)
		momentum++;
	
	check_for_brake();
	move(move_speed, facing);	
}
brake	= function() {
	if (momentum > 1)
		move(1, facing);	
	momentum--;		
	
	// Momentum Exhausted
	if (momentum <= 0) {
		action = idle;
		state  = "idle";
	}
}
idle	= function() {
	momentum = 0;
}
action	= drive;