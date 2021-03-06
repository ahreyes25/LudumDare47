event_inherited();

off				= false;
entity			= ENTITY.CAR;

action			= undefined;
max_momentum	= 2;
momentum		= (starting_momentum != undefined) ? starting_momentum : 0;
hangtime		= 0;
move_speed		= 1;
action			= undefined;
state			= "drive";
list			= ds_list_create();
crash_angle		= undefined;
crash_axis		= undefined;
editing			= false;
status_sprite	= spr_status_arrow;

// Load Car Model
var _color = obj_game.car_colors[| obj_game.cars_created];
if (_color == 1)	var _type = global.car1_model;
if (_color == 2)	var _type = global.car2_model;
if (_color == 3)	var _type = global.car3_model;
model = new Model_Instance(_type);
model.scale(SCALE_3D + 5);
model.zscale += 10;
model.yscale += 5
model.x = x;
model.y = y;
model.z = z;
obj_game.cars_created++;
xscale		=  1;
yscale		=  1;
depth		=  0;
u_xscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_xscale");
u_yscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_yscale");

update_uvs();
store_in_grid();

check_for_brake	= function() {
	// Check For Cars
	ds_list_clear(list);
	var _car_coords = grid_check_for(ENTITY.CAR, u, v, facing, momentum + 1);
	if (_car_coords[0] != undefined && _car_coords[1] != undefined) {
		grid_get_instances_at(ENTITY.CAR, _car_coords[0], _car_coords[1], list, true);
		var _car = list[| 0];
		
		if (_car != noone && _car != undefined && _car.state != "ascend" && _car.state != "descend" && (_car.momentum < _car.max_momentum || _car.state == "brake"))  {
			action = brake;
			state  = "brake";
		}
	}
	
	// Check For Stoplights
	if (state != "brake") {
		ds_list_clear(list);
		var _stoplight_coords = grid_check_for(ENTITY.STOPLIGHT, u, v, facing, momentum + 1);
		if (_stoplight_coords[0] != undefined && _stoplight_coords[1] != undefined) {
			grid_get_instances_at(ENTITY.STOPLIGHT, _stoplight_coords[0], _stoplight_coords[1], list, true);
			var _stoplight = list[| 0];

			if (_stoplight != noone && _stoplight != undefined) {
				
				var _facing_same = (
					facing == DIR.RIGHT && _stoplight.facing == DIR.LEFT  ||
					facing == DIR.LEFT	&& _stoplight.facing == DIR.RIGHT ||
					facing == DIR.UP	&& _stoplight.facing == DIR.DOWN  ||
					facing == DIR.DOWN	&& _stoplight.facing == DIR.UP
				);
				
				if (_facing_same) {
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
	
	// Check For Crash Stack
	if (state != "brake") {
		var _crash_coords = grid_check_for_crash(id, u, v, facing, momentum + 1);
		if (_crash_coords[0] != undefined && _crash_coords[1] != undefined) {
			action = brake;
			state  = "brake";
		}
	}
	
	// Check For Sideways Ramps
	if (state != "brake") {
		ds_list_clear(list);
		var _ramp_coords = grid_check_for(ENTITY.CAR, u, v, facing, momentum + 1, ENTITY.RAMP);
		if (_ramp_coords[0] != undefined && _ramp_coords[1] != undefined) {
			grid_get_instances_at(ENTITY.RAMP, _ramp_coords[0], _ramp_coords[1], list, true);
			
			var _ramp = list[| 0];
			if (_ramp != noone && _ramp != undefined)  {
				var _sideways = (
					(_ramp.facing == DIR.RIGHT	&& facing != DIR.RIGHT)	||
					(_ramp.facing == DIR.LEFT	&& facing != DIR.LEFT)	||
					(_ramp.facing == DIR.UP		&& facing != DIR.UP)	||
					(_ramp.facing == DIR.DOWN	&& facing != DIR.DOWN)
				);
				
				if (_sideways) {
					action = brake;
					state  = "brake";
				}
			}
		}
	}
		
	// Check For Cones
	if (state != "brake") {
		ds_list_clear(list);
		var _cone_coords = grid_check_for(ENTITY.CONE, u, v, facing, momentum + 1);
		if (_cone_coords[0] != undefined && _cone_coords[1] != undefined) {
			grid_get_instances_at(ENTITY.CONE, _cone_coords[0], _cone_coords[1], list, true);
			
			var _cone = list[| 0];
			if (_cone != noone && _cone != undefined)  {
				action = brake;
				state  = "brake";
			}
		}
	}
		
	if (state == "brake")
		audio_play_sound(sfx_brake, 0, 0);
}
check_for_drive = function() {
	var _car_pass = false;
	var _car = grid_adjacent(GRID_CARS, u, v, facing);
	if (_car == CAR.NONE)
		_car_pass = true;
	else {
		ds_list_clear(list);
		switch (facing) {
			case DIR.RIGHT:	var _car_count = grid_get_instances_at(ENTITY.CAR, u + 1, v, list, true);	break;	
			case DIR.LEFT:	var _car_count = grid_get_instances_at(ENTITY.CAR, u - 1, v, list, true);	break;	
			case DIR.UP:	var _car_count = grid_get_instances_at(ENTITY.CAR, u, v - 1, list, true);	break;	
			case DIR.DOWN:	var _car_count = grid_get_instances_at(ENTITY.CAR, u, v + 1, list, true);	break;	
		}
		
		var _all_pass = true;
		for (var i = 0; i < _car_count; i++) {
			var _car_inst = list[| i];
			if (_car_inst.id == id)
				continue;
				
			if (_car_inst.state != "ascend" && _car_inst.state != "descend") 
				_all_pass = false;
			break;
		}
		_car_pass = _all_pass;
	}
		
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
	
	var _crash_pass = false;
	var _coords = grid_check_for_crash(id, u, v, facing, 1);
	if (_coords[0] == undefined && _coords[1] == undefined)
		_crash_pass = true;
		
	var _ramp_pass = false;
	var _coords = grid_check_for(ENTITY.CAR, u, v, facing, 1, ENTITY.RAMP);
	if (_coords[0] == undefined && _coords[1] == undefined)
		_ramp_pass = true;
		
	var _cone_pass = false;
	var _coords = grid_check_for(ENTITY.CONE, u, v, facing, 1);
	if (_coords[0] == undefined && _coords[1] == undefined)
		_cone_pass = true;
		
	// Dont Pass Lights If Sitting In Crosswalk
	if (GRID_LIGHTS[# u, v] != LIGHT.NONE)
		_light_pass = false;
	
	if (_car_pass && _light_pass && _crash_pass && _ramp_pass && _cone_pass) {
		action =  drive;
		state  = "drive";
	}
}

drive	= function() {
	if (momentum < max_momentum)
		momentum++;
	
	check_for_brake();
	move(move_speed, facing);	
	status_sprite = spr_status_arrow;
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
	status_sprite = spr_status_brake;
}
idle	= function() {
	momentum = 0;
	check_for_drive();
	status_sprite = undefined;
}
ascend	= function() {
	move(move_speed, facing);	
	target_z -= UNIT_SIZE * 0.5
	
	hangtime--;
	if (hangtime <= 0) {
		state  = "descend";
		action = descend;
	}
	status_sprite = spr_status_ascend;
}
descend = function() {
	move(move_speed, facing);	
	target_z += UNIT_SIZE * 0.5
	
	if (target_z >= -UNIT_SIZE * 0.1) {
		state  = "drive";
		action = drive;
	}
	status_sprite = spr_status_descend;
}
action	= drive;

do_crash	= function() {
	music_set(1);
	action = undefined;
	state  = "crash";
		
	if (GRID_CRASHES[# u, v] == undefined)
		GRID_CRASHES[# u, v] = ds_list_create();
	var _zoffset = ds_list_size(GRID_CRASHES[# u, v]);
	ds_list_add(GRID_CRASHES[# u, v], id);
		
	model.xangle_target = random_range(-90, 90);
	model.zangle_target = random_range(-90, 90);
	target_z = -_zoffset * UNIT_SIZE * 0.5;
	status_sprite = undefined;
	audio_play_sound(choose(sfx_scream_1, sfx_scream_2, sfx_scream_3, sfx_scream_4, sfx_scream_5, sfx_scream_6), 0, false);
	audio_play_sound(sfx_crash, 0, false);
	audio_play_sound(choose(sfx_exp_1, sfx_exp_2, sfx_exp_3, sfx_exp_4, sfx_exp_5, sfx_exp_6), 0, false);
	
	create_curse_word(x, y);
}
	
	