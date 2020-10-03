event_inherited();

entity			= ENTITY.CAR;
action			= undefined;
max_momentum	= 2;
momentum		= max_momentum;
move_speed		= 1;
stoplight		= noone;
action			= undefined;
state			= "drive";
ds_list_add(LIST_ENTITIES, id);

move			= function(_move_speed, _dir) {
	switch (_dir) {
		case DIR.RIGHT:	x += UNIT_SIZE * move_speed;	break;
		case DIR.LEFT:	x -= UNIT_SIZE * move_speed;	break;
		case DIR.UP:	y -= UNIT_SIZE * move_speed;	break;
		case DIR.DOWN:	y += UNIT_SIZE * move_speed;	break;
	}
}
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
	var _car = get_car(facing, momentum + 1);
	if (_car != noone && (_car.state == "brake" || _car.state == "idle"))  {
		action = brake;
		state  = "brake";
	}
	
	stoplight = get_stoplight(facing, momentum + 1);
	if (stoplight != noone) {
		var _stoplight_coords	= world_to_grid(stoplight.x, stoplight.y);
		var _stoplight_u		= _stoplight_coords[0];
		var _stoplight_v		= _stoplight_coords[1];
	
		if (stoplight.light == "red")  {
			action = brake;
			state  = "brake";
		}
		else if (stoplight.light == "yellow") {
			switch (facing) {
				case DIR.RIGHT:
					if (u_curr < _stoplight_u && abs(u_curr - _stoplight_u) - 1 >= momentum) {
						action = brake;
						state  = "brake";
					}
					break;
				case DIR.LEFT:
					if (u_curr > _stoplight_u && abs(u_curr - _stoplight_u) - 1 >= momentum) {
						action = brake;
						state  = "brake";
					}
					break;
				case DIR.DOWN:
					if (v_curr < _stoplight_u && abs(v_curr - _stoplight_v) - 1 >= momentum) {
						action = brake;
						state  = "brake";
					}
					break;
				case DIR.UP:
					if (v_curr > _stoplight_v && abs(v_curr - _stoplight_v) - 1 >= momentum) {
						action = brake;
						state  = "brake";
					}
					break;
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
		if (adjacent_free(facing)) {
			action = drive;
			state  = "drive";
			//move(1, facing);
		}
		else {
			action = idle;
			state  = "idle";
		}
	}
}
idle	= function() {
	momentum = 0;
}
action	= drive;