grid_width		= sprite_width  div UNIT_SIZE;
grid_height		= sprite_height div UNIT_SIZE;
quad_size		= 7;
sidewalk_width	= 1;
depth			= 100;
action_interval	= 30;
center_x		= x + (grid_width  * UNIT_SIZE / 2);
center_y		= y + (grid_height * UNIT_SIZE / 2);
world_3d		= undefined;

// Functions
draw_grid				= function() {		
	for (var i = 0; i < grid_width; i++) {
		for (var j = 0; j < grid_height; j++) {
			var _coords = grid_to_world(i, j);
			switch (GRID_ENVIRONMENT[# i, j]) {
				case ENVIRONMENT.SIDEWALK:		var _color = c_ltgray;	break;
				case ENVIRONMENT.ROAD:			var _color = c_dkgray;	break;
				case ENVIRONMENT.BUILDING:		var _color = c_gray;	break;
				case ENVIRONMENT.GRASS:			var _color = c_green;	break;
				case ENVIRONMENT.PARKING_LOT:	var _color = c_black;	break;
				case ENVIRONMENT.TURNING_LANE:	var _color = c_yellow;	break;
				case ENVIRONMENT.CROSS_WALK:	var _color = c_orange;	break;
			}
			draw_rectangle_alt(_coords[0], _coords[1], UNIT_SIZE, UNIT_SIZE, 0, _color, 1);
		}
	}
	
	for (var i = 0; i <= grid_width; i++)
		draw_line_color(x + i * UNIT_SIZE, y, x + i * UNIT_SIZE, y + grid_height * UNIT_SIZE, c_black, c_black);
	for (var j = 0; j <= grid_height; j++)
		draw_line_color(x, y + j * UNIT_SIZE, x + grid_width * UNIT_SIZE, y + j * UNIT_SIZE, c_black, c_black);	
}
fill_grid				= function() {
	for (var i = quad_size + sidewalk_width; i < grid_width - quad_size - sidewalk_width; i++) {	// road
		for (var j = 0; j < grid_height; j++)
			GRID_ENVIRONMENT[# i, j] = ENVIRONMENT.ROAD;	
	}
	for (var j = quad_size + sidewalk_width; j < grid_height - quad_size - sidewalk_width; j++) {	// road
		for (var i = 0; i < grid_width; i++)
			GRID_ENVIRONMENT[# i, j] = ENVIRONMENT.ROAD;	
	}
	for (var i = 0; i < quad_size; i++) {							// NW
		for (var j = 0; j < quad_size; j++)
			GRID_ENVIRONMENT[# i, j] = ENVIRONMENT.BUILDING;
	}
	for (var i = grid_width - quad_size; i < grid_width; i++) {		// NE
		for (var j = 0; j < quad_size; j++)
			GRID_ENVIRONMENT[# i, j] = ENVIRONMENT.BUILDING;
	}
	for (var i = 0; i < quad_size; i++) {							// SW
		for (var j = grid_height - quad_size; j < grid_height; j++)
			GRID_ENVIRONMENT[# i, j] = ENVIRONMENT.PARKING_LOT;
	}
	for (var i = grid_width - quad_size; i < grid_width; i++) {		// SE
		for (var j = grid_height - quad_size; j < grid_height; j++)
			GRID_ENVIRONMENT[# i, j] = ENVIRONMENT.GRASS;
	}
	for (var i = quad_size + sidewalk_width; i < grid_width - quad_size - sidewalk_width; i++) {	// crosswalk
		for (j = quad_size + sidewalk_width - 1; j < quad_size + sidewalk_width; j++)
			GRID_ENVIRONMENT[# i, j] = ENVIRONMENT.CROSS_WALK;
	}
	for (var i = quad_size + sidewalk_width; i < grid_width - quad_size - sidewalk_width; i++) {	// crosswalk
		for (j = grid_height - quad_size + sidewalk_width - 2; j < grid_height - quad_size + sidewalk_width - 1; j++)
			GRID_ENVIRONMENT[# i, j] = ENVIRONMENT.CROSS_WALK;
	}
	for (var j = quad_size + sidewalk_width; j < grid_height - quad_size - sidewalk_width; j++) {	// crosswalk
		for (i = quad_size + sidewalk_width - 1; i < quad_size + sidewalk_width; i++)
			GRID_ENVIRONMENT[# i, j] = ENVIRONMENT.CROSS_WALK;
	}
	for (var j = quad_size + sidewalk_width; j < grid_height - quad_size - sidewalk_width; j++) {	// crosswalk
		for (i = grid_width - quad_size + sidewalk_width - 2; i < grid_width - quad_size + sidewalk_width - 1; i++)
			GRID_ENVIRONMENT[# i, j] = ENVIRONMENT.CROSS_WALK;
	}

	for (var i = 0; i < grid_width; i++) {
		if (i > quad_size + sidewalk_width - 2 && i < grid_width - quad_size - sidewalk_width + 1)	// turning lane
			continue;
		GRID_ENVIRONMENT[# i, grid_height div 2] = ENVIRONMENT.TURNING_LANE;	
	}
	for (var j = 0; j < grid_width; j++) {
		if (j > quad_size + sidewalk_width - 2 && j < grid_height - quad_size - sidewalk_width + 1)	// turning lane
			continue;
		GRID_ENVIRONMENT[# grid_width div 2, j] = ENVIRONMENT.TURNING_LANE;	
	}	
}
capture_environment		= function() {
	var _list		= ds_list_create();
	var _objects	= [obj_building, obj_grass, obj_sidewalk, obj_turning_lane, obj_crosswalk];

	for (var i = 0; i < array_length(_objects); i++) {
		var _object_index = _objects[i];
		var _object_count = collision_rectangle_list(x, y, x + sprite_width, y + sprite_height, _object_index, false, false, _list, false);
	
		for (var j = 0; j < _object_count; j++) {
			var _object = _list[| j];
			if (_object != noone && _object != undefined) {
				for (var k = 0; k < _object.sprite_width; k += UNIT_SIZE) {
					for (var l = 0; l < _object.sprite_height; l += UNIT_SIZE) {
						if (grid_in_bounds(GRID_ENVIRONMENT, k div UNIT_SIZE, l div UNIT_SIZE)) {
							var _coords = world_to_grid(_object.x + k, _object.y + l);
						
							switch (i) {
								case 0:	GRID_ENVIRONMENT[# _coords[0], _coords[1]] = ENVIRONMENT.BUILDING;		break;
								case 1: GRID_ENVIRONMENT[# _coords[0], _coords[1]] = ENVIRONMENT.GRASS;		break;
								case 2: GRID_ENVIRONMENT[# _coords[0], _coords[1]] = ENVIRONMENT.SIDEWALK;		break;
								case 3: GRID_ENVIRONMENT[# _coords[0], _coords[1]] = ENVIRONMENT.TURNING_LANE;	break;
								case 4: GRID_ENVIRONMENT[# _coords[0], _coords[1]] = ENVIRONMENT.CROSS_WALK;	break;
							}
						}
					}
				}
			}
		}
		ds_list_clear(_list);
	}
	ds_list_destroy(_list);
}
act_on_entities			= function() {
	for (var i = ds_list_size(LIST_ENTITIES) - 1; i >= 0; i--) {
		var _entity = LIST_ENTITIES[| i];
		
		if (obj_cursor.selected_object != undefined) {
			if (obj_cursor.selected_object == _entity)
				continue;
		}
		
		var _exists = instance_exists(_entity);
		if (_exists && _entity.action != undefined) {
			if (_entity.object_index == obj_car) {
				if (!_entity.off)
					_entity.action();
			}
			else
				_entity.action();
		}
		else if (!_exists)
			ds_list_delete(LIST_ENTITIES, i);
	}	
}

resize_grids(grid_width, grid_height);
clear_structures();
capture_environment();

var _car_pos = [
	[center_x - sprite_width * 0.36, center_y + sprite_height * 0.25 + UNIT_SIZE],
];

for (var i = 0; i < 2; i++) {
	var _pos = _car_pos[0];
	var _x	 = _pos[0];
	var _y	 = _pos[1] + UNIT_SIZE * i;
	var _car = instance_create_depth(_x, _y, depth, obj_car);
	_car.zangle = (i == 0) ? 90 : 270;
	_car.action = undefined;
}











