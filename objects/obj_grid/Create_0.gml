enum UNIT { 
	SIDEWALK, ROAD, BUILDING, GRASS, PARKING_LOT, 
	TURNING_LANE, CROSS_WALK,
}

unit_size		= 24;
grid_width		= sprite_width  div unit_size;
grid_height		= sprite_height div unit_size;
grid			= ds_grid_create(grid_width, grid_height);
quad_size		= 7;
sidewalk_width	= 1;
depth			= 100;
ds_grid_clear(grid, UNIT.ROAD);

// Functions
draw_grid		= function() {		
	for (var i = 0; i < grid_width; i++) {
		for (var j = 0; j < grid_height; j++) {
			var _coords = grid_to_world(i, j);
			switch (grid[# i, j]) {
				case UNIT.SIDEWALK:		var _color = c_ltgray;	break;
				case UNIT.ROAD:			var _color = c_dkgray;	break;
				case UNIT.BUILDING:		var _color = c_gray;	break;
				case UNIT.GRASS:		var _color = c_green;	break;
				case UNIT.PARKING_LOT:	var _color = c_black;	break;
				case UNIT.TURNING_LANE:	var _color = c_yellow;	break;
				case UNIT.CROSS_WALK:	var _color = c_orange;	break;
			}
			draw_rectangle_alt(_coords[0], _coords[1], unit_size, unit_size, 0, _color, 1);
		}
	}
	
	for (var i = 0; i <= grid_width; i++)
		draw_line(x + i * unit_size, y, x + i * unit_size, y + grid_height * unit_size);
	for (var j = 0; j <= grid_height; j++)
		draw_line(x, y + j * unit_size, x + grid_width * unit_size, y + j * unit_size);	
}
world_to_grid	= function(_x, _y) {
	var _u = (_x - x) div unit_size;
	var _v = (_y - y) div unit_size;
	return [_u, _v];
}
grid_to_world	= function(_u, _v) {
	var _x = x + _u * unit_size;
	var _y = y + _v * unit_size;
	return [_x, _y];
}
fill_grid		= function() {
	for (var i = quad_size + sidewalk_width; i < grid_width - quad_size - sidewalk_width; i++) {	// road
		for (var j = 0; j < grid_height; j++)
			grid[# i, j] = UNIT.ROAD;	
	}
	for (var j = quad_size + sidewalk_width; j < grid_height - quad_size - sidewalk_width; j++) {	// road
		for (var i = 0; i < grid_width; i++)
			grid[# i, j] = UNIT.ROAD;	
	}
	for (var i = 0; i < quad_size; i++) {							// NW
		for (var j = 0; j < quad_size; j++)
			grid[# i, j] = UNIT.BUILDING;
	}
	for (var i = grid_width - quad_size; i < grid_width; i++) {		// NE
		for (var j = 0; j < quad_size; j++)
			grid[# i, j] = UNIT.BUILDING;
	}
	for (var i = 0; i < quad_size; i++) {							// SW
		for (var j = grid_height - quad_size; j < grid_height; j++)
			grid[# i, j] = UNIT.PARKING_LOT;
	}
	for (var i = grid_width - quad_size; i < grid_width; i++) {		// SE
		for (var j = grid_height - quad_size; j < grid_height; j++)
			grid[# i, j] = UNIT.GRASS;
	}
	for (var i = quad_size + sidewalk_width; i < grid_width - quad_size - sidewalk_width; i++) {	// crosswalk
		for (j = quad_size + sidewalk_width - 1; j < quad_size + sidewalk_width; j++)
			grid[# i, j] = UNIT.CROSS_WALK;
	}
	for (var i = quad_size + sidewalk_width; i < grid_width - quad_size - sidewalk_width; i++) {	// crosswalk
		for (j = grid_height - quad_size + sidewalk_width - 2; j < grid_height - quad_size + sidewalk_width - 1; j++)
			grid[# i, j] = UNIT.CROSS_WALK;
	}
	for (var j = quad_size + sidewalk_width; j < grid_height - quad_size - sidewalk_width; j++) {	// crosswalk
		for (i = quad_size + sidewalk_width - 1; i < quad_size + sidewalk_width; i++)
			grid[# i, j] = UNIT.CROSS_WALK;
	}
	for (var j = quad_size + sidewalk_width; j < grid_height - quad_size - sidewalk_width; j++) {	// crosswalk
		for (i = grid_width - quad_size + sidewalk_width - 2; i < grid_width - quad_size + sidewalk_width - 1; i++)
			grid[# i, j] = UNIT.CROSS_WALK;
	}

	for (var i = 0; i < grid_width; i++) {
		if (i > quad_size + sidewalk_width - 2 && i < grid_width - quad_size - sidewalk_width + 1)	// turning lane
			continue;
		grid[# i, grid_height div 2] = UNIT.TURNING_LANE;	
	}
	for (var j = 0; j < grid_width; j++) {
		if (j > quad_size + sidewalk_width - 2 && j < grid_height - quad_size - sidewalk_width + 1)	// turning lane
			continue;
		grid[# grid_width div 2, j] = UNIT.TURNING_LANE;	
	}	
}
	
#region Capture Environment Objects Into Grid
var _list		= ds_list_create();
var _objects	= [obj_building, obj_grass, obj_sidewalk, obj_turning_lane, obj_crosswalk];

for (var i = 0; i < array_length(_objects); i++) {
	var _object_index = _objects[i];
	var _object_count = collision_rectangle_list(x, y, x + sprite_width, y + sprite_height, _object_index, false, false, _list, false);
	
	for (var j = 0; j < _object_count; j++) {
		var _object = _list[| j];
		if (_object != noone && _object != undefined) {
			for (var k = 0; k < _object.sprite_width; k += unit_size) {
				for (var l = 0; l < _object.sprite_height; l += unit_size) {
					if (grid_in_bounds(grid, k div unit_size, l div unit_size)) {
						var _coords = world_to_grid(_object.x + k, _object.y + l);
						
						switch (i) {
							case 0:	grid[# _coords[0], _coords[1]] = UNIT.BUILDING;		break;
							case 1: grid[# _coords[0], _coords[1]] = UNIT.GRASS;		break;
							case 2: grid[# _coords[0], _coords[1]] = UNIT.SIDEWALK;		break;
							case 3: grid[# _coords[0], _coords[1]] = UNIT.TURNING_LANE;	break;
							case 4: grid[# _coords[0], _coords[1]] = UNIT.CROSS_WALK;	break;
						}
					}
				}
			}
		}
	}
	ds_list_clear(_list);
}
ds_list_destroy(_list);
#endregion





















