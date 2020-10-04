event_inherited();

entity			= ENTITY.CAR;
action			= undefined;
max_momentum	= 2;
momentum		= max_momentum;
move_speed		= 1;
action			= undefined;
state			= "drive";
list			= ds_list_create();

// Load Car Model
model = dotobj_model_load_file("Car-1.obj", true, true);
model.scale(SCALE_3D);
model.x = x;
model.y = y;
model.z = z;

update_uvs();
store_in_grid();

check_for_brake	= function() {
	// Check For Cars To Start Braking
	ds_list_clear(list);
	var _car_coords = grid_check_for(ENTITY.CAR, u, v, facing, momentum + 1);
	if (_car_coords[0] != undefined && _car_coords[1] != undefined) {
		grid_get_instances_at(ENTITY.CAR, _car_coords[0], _car_coords[1], list, true);
		var _car = list[| 0];
		
		if (_car != noone && _car != undefined && (_car.momentum < _car.max_momentum))  {
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
	
				if (facing == DIR.LEFT || facing == DIR.RIGHT) {
					var _dist	= abs(u - _stoplight_u);
					var _not_in = (u != _stoplight_u);
				}
				else {
					var _dist	= abs(v - _stoplight_v);
					var _not_in = (v != _stoplight_v);
				}
				
				if (_not_in && _stoplight.light == "red")  {
					action = brake;
					state  = "brake";
				}
				else if (_not_in && _stoplight.light == "yellow") {
					switch (facing) {
						case DIR.RIGHT:
							if (u < _stoplight_u && _dist - 1 >= momentum && _stoplight.light_count <= momentum + 1) {
								action = brake;
								state  = "brake";
							}
							break;
							
						case DIR.LEFT:
							if (u > _stoplight_u && _dist - 1 >= momentum && _stoplight.light_count <= momentum + 1) {
								action = brake;
								state  = "brake";
							}
							break;
							
						case DIR.DOWN:
							if (v < _stoplight_v && _dist - 1 >= momentum && _stoplight.light_count <= momentum + 1) {
								action = brake;
								state  = "brake";
							}
							break;
							
						case DIR.UP:
							if (v > _stoplight_v && _dist - 1 >= momentum && _stoplight.light_count <= momentum + 1) {
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
check_for_drive = function() {
	var _car_pass = false;
	var _car = grid_adjacent(GRID_CARS, u, v, facing);
	if (_car == CAR.NONE)
		_car_pass = true;
		
	var _light_pass = false;
	var _light = grid_adjacent(GRID_LIGHTS, u, v, facing);
	if (_light == LIGHT.NONE)
		_light_pass = true;
	else {
		ds_list_clear(list);
		var _light_uv = grid_uv_adjacent(u, v, facing);
		grid_get_instances_at(ENTITY.STOPLIGHT, _light_uv[0], _light_uv[1], list, false);
		var _light_inst = list[| 0];
		if (_light_inst.light == "green")
			_light_pass = true;
		else if (_light_inst.light == "yellow" && _light_inst.light_count > 1)
			_light_pass = true;
	}
	
	if (_car_pass && _light_pass) {
		action =  drive;
		state  = "drive";
	}
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
	check_for_drive();
}
action	= drive;