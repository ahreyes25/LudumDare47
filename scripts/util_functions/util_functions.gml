/// @function vertex_add_point(vbuffer, x, y, z, nx, ny, nz, utex, vtex, color, alpha)
function vertex_add_point(_vbuffer, _x, _y, _z, _nx, _ny, _nz, _utex, _vtex, _color, _alpha) {
	vertex_position_3d(_vbuffer, _x, _y, _z);
	vertex_normal(_vbuffer, _nx, _ny, _nz);
	vertex_color(_vbuffer, _color, _alpha);
	vertex_texcoord(_vbuffer, _utex, _vtex);
}

/// @function draw_sprite_billboard_cylinder(sprite, subimage, x, y, z)  
function draw_sprite_billboard_cylinder(_sprite, _subimage, _x, _y, _z) {
    matrix_set(matrix_world, matrix_build(_x, _y, _z, 0, 0, 0, 1, 1, 1));
    draw_sprite_ext(_sprite, _subimage, 0, 0, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    matrix_set(matrix_world, matrix_build_identity());
}

/// @function draw_sprite_billboard_sphere(sprite, subimage, x, y, z)  
function draw_sprite_billboard_sphere(_sprite, _subimage, _x, _y, _z) {
    matrix_set(matrix_world, matrix_build(_x, _y, _z, 0, 0, 0, 1, 1, 1));
    draw_sprite(_sprite, _subimage, 0, 0);
    matrix_set(matrix_world, matrix_build_identity());
}

/// @function draw_rectangle_alt(x, y, width, height, rot, col, alpha)
function draw_rectangle_alt(_x, _y, _width, _height, _rot, _col, _alpha) {
	draw_sprite_ext(spr_white, 0, _x, _y, _width, _height, _rot, _col, _alpha);	
}

/// @function grid_in_bounds(grid, i, j)
function grid_in_bounds(_grid, _i, _j) {
	return (
		_i >= 0 && _i <= ds_grid_width(_grid)  - 1 &&
		_j >= 0 && _j <= ds_grid_height(_grid) - 1
	);	
}
	
/// @function world_to_grid(x, y)
function world_to_grid(_x, _y) {
	var _u = (_x - obj_grid.x) div UNIT_SIZE;
	var _v = (_y - obj_grid.y) div UNIT_SIZE;
	return [_u, _v];
}

/// @function grid_to_world(u, v)
function grid_to_world(_u, _v) {
	var _x = obj_grid.x + _u * UNIT_SIZE;
	var _y = obj_grid.y + _v * UNIT_SIZE;
	return [_x, _y];
}
	
/// @function clear_structures()
function clear_structures()  {
	ds_list_clear(LIST_ENTITIES);
	ds_grid_clear(GRID_ENVIRONMENT, ENVIRONMENT.ROAD);
	ds_grid_clear(GRID_LIGHTS,		LIGHT.NONE);
	ds_grid_clear(GRID_CARS,		CAR.NONE);		
	ds_grid_clear(GRID_CHARS,		CHAR.NONE);		
	ds_grid_clear(GRID_CONES,		CONE.NONE);		
	
	// Destroy Lists Stored In Grid First
	for (var i = 0; i < ds_grid_width(GRID_CRASHES); i++) {
		for (var j = 0; j < ds_grid_height(GRID_CRASHES); j++) {
			var _value = GRID_CRASHES[# i, j];
			if (_value != undefined)
				ds_list_destroy(_value);
		}
	}
	ds_grid_clear(GRID_CRASHES,		undefined);		
}

/// @function resize_grids(width, height)
function resize_grids(_width, _height) {
	ds_grid_resize(GRID_ENVIRONMENT, _width, _height);
	ds_grid_resize(GRID_LIGHTS,		 _width, _height);
	ds_grid_resize(GRID_CARS,		 _width, _height);
	ds_grid_resize(GRID_CHARS,		 _width, _height);
	ds_grid_resize(GRID_CRASHES,	 _width, _height);
	ds_grid_resize(GRID_CONES,	 _width, _height);
}
	
/// @function grid_adjacent(grid, u, v, dir)
function grid_adjacent(_grid, _u, _v, _dir) {
	switch (_dir) {
		case DIR.RIGHT: return _grid[# _u + 1, _v]; break;
		case DIR.LEFT:	return _grid[# _u - 1, _v]; break;
		case DIR.UP:	return _grid[# _u, _v - 1]; break;
		case DIR.DOWN:	return _grid[# _u, _v + 1]; break;
	}
}

/// @function grid_uv_adjacent(u, v, dir)
function grid_uv_adjacent(_u, _v, _dir) {
	switch (_dir) {
		case DIR.RIGHT: return [_u + 1, _v]; break;
		case DIR.LEFT:	return [_u - 1, _v]; break;
		case DIR.UP:	return [_u, _v - 1]; break;
		case DIR.DOWN:	return [_u, _v + 1]; break;
	}
}

/// @function grid_check_for(entity, u, v, dir, dist, specific_entity_enum*)
function grid_check_for(_entity, _u, _v, _dir, _dist) {
	var _i				= undefined;
	var _j				= undefined;
	var _enum			= argument_count == 6 ? argument[5] : undefined;
	var _grid			= grid_get_grid(_entity);
	var _empty_value	= grid_get_empty_value(_entity);
	
	switch (_dir) {
		case DIR.RIGHT:
			for (var i = _u + 1; i <= _u + _dist; i++) {
				if (grid_in_bounds(_grid, i, _v)) {
					if ((_enum == undefined && _grid[# i, _v] != _empty_value) || _grid[# i, _v] == _enum) {
						_i =  i;
						_j = _v;
						break;
					}
				} else break;
			}
			break;
		case DIR.LEFT:
			for (var i = _u - 1; i >= _u - _dist; i--) {
				if (grid_in_bounds(_grid, i, _v)) {
					if ((_enum == undefined && _grid[# i, _v] != _empty_value) || _grid[# i, _v] == _enum) {
						_i =  i;
						_j = _v;
						break;
					}
				} else break;
			}
			break;
		case DIR.UP:
			for (var j = _v - 1; j >= _v - _dist; j--) {
				if (grid_in_bounds(_grid, _u, j)) {
					if ((_enum == undefined && _grid[# _u, j] != _empty_value) || _grid[# _u, j] == _enum) {
						_i = _u;
						_j =  j;
						break;
					}
				} else break;
			}
			break;
		case DIR.DOWN:
			for (var j = _v + 1; j <= _v + _dist; j++) {
				if (grid_in_bounds(_grid, _u, j)) {
					if ((_enum == undefined && _grid[# _u, j] != _empty_value) || _grid[# _u, j] == _enum) {
						_i = _u;
						_j =  j;
						break;
					}
				} else break;
			}
			break;
	}
	return [_i, _j];
}
	
/// @function grid_get_instances_at(entity, u, v, list, notme)
function grid_get_instances_at(_entity, _u, _v, _list, _notme) {
	var _coords = grid_to_world(_u, _v);
	var _count	= collision_rectangle_list(_coords[0] + 1, _coords[1] + 1, _coords[0] + UNIT_SIZE - 1, _coords[1] + UNIT_SIZE - 1, obj_entity, false, _notme, _list, false);
	var _number = _count;
	
	for (var i = _count - 1; i >= 0; i--) {
		var _inst = _list[| i];
		if (_inst.entity != _entity) {
			ds_list_delete(_list, i);
			_number--;
		}
	}
	return _number;
}

/// @function grid_get_entities_at(entity, u, v)
function grid_get_entities_at(_entity, _u, _v) {
	switch (_entity) {
		case ENTITY.CAR:		return GRID_CARS[# _u, _v];		break;
		case ENTITY.CHAR:		return GRID_CHARS[# _u, _v];	break;
		case ENTITY.STOPLIGHT:	return GRID_LIGHTS[# _u, _v];	break;
		case ENTITY.CONE:		return GRID_CONES[# _u, _v];	break;
	}
}

/// @function grid_get_empty_value(entity)
function grid_get_empty_value(_entity) {
	switch (_entity) {
		case ENTITY.CAR:		return CAR.NONE;
		case ENTITY.CHAR:		return CHAR.NONE;
		case ENTITY.STOPLIGHT:	return LIGHT.NONE;
		case ENTITY.CONE:		return CONE.NONE;
		default:				return 0;
	}
}
	
/// @function grid_get_grid(entity)
function grid_get_grid(_entity) {
	switch (_entity) {
		case ENTITY.CAR:		return GRID_CARS;	break;
		case ENTITY.CHAR:		return GRID_CHARS;	break;
		case ENTITY.STOPLIGHT:	return GRID_LIGHTS;	break;
		case ENTITY.CONE:		return GRID_CONES;	break;
	}
}
	
/// @function grid_check_for_crash(id, u, v, dir, dist)
function grid_check_for_crash(_id, _u, _v, _dir, _dist) {
	var _i				= undefined;
	var _j				= undefined;
	var _grid			= GRID_CRASHES;
	
	switch (_dir) {
		case DIR.RIGHT:
			for (var i = _u + 1; i <= _u + _dist; i++) {
				if (grid_in_bounds(_grid, i, _v)) {
					if (GRID_CRASHES[# i, _v] != undefined) {
						_i =  i;
						_j = _v;
						break;
					}
				} else break;
			}
			break;
		case DIR.LEFT:
			for (var i = _u - 1; i >= _u - _dist; i--) {
				if (grid_in_bounds(_grid, i, _v)) {
					if (GRID_CRASHES[# i, _v] != undefined) {
						_i =  i;
						_j = _v;
						break;
					}
				} else break;
			}
			break;
		case DIR.UP:
			for (var j = _v - 1; j >= _v - _dist; j--) {
				if (grid_in_bounds(_grid, _u, j)) {
					if (GRID_CRASHES[# _u, j] != undefined) {
						_i = _u;
						_j =  j;
						break;
					}
				} else break;
			}
			break;
		case DIR.DOWN:
			for (var j = _v + 1; j <= _v + _dist; j++) {
				if (grid_in_bounds(_grid, _u, j)) {
					if (GRID_CRASHES[# _u, j] != undefined) {
						_i = _u;
						_j =  j;
						break;
					}
				} else break;
			}
			break;
	}
	return [_i, _j];
}
	
/// @function bezier_quadratic_get_point(point0, point1, point2, t)
function bezier_quadratic_get_point(argument0, argument1, argument2, argument3) {
	var _p0 = argument0;
	var _p1 = argument1;
	var _p2 = argument2;
	var _t	= argument3;

	return [
		(power(1 - _t, 2) * _p0[0]) + ((1 - _t) * 2 * _t * _p1[0]) + (_t * _t * _p2[0]),
		(power(1 - _t, 2) * _p0[1]) + ((1 - _t) * 2 * _t * _p1[1]) + (_t * _t * _p2[1])
	];
}

/// @function blood_particle_create(x, y)
function blood_particle_create(_x, _y) {
	var _blood = instance_create_depth(_x, _y, depth, obj_particle);
	_blood.sprite_index = spr_blood_particle;
	_blood.image_index  = irandom(_blood.image_number - 1);
	_blood.image_speed  = 0;
	_blood.xscale		= random_range(0.6, 1.0);
	_blood.yscale		= _blood.xscale;
	_blood.z			= z - sprite_height / 2;
	_blood.height		= 50;
	_blood.iter_speed	= 0.02;
}

/// @function water_particle_create(x, y)
function water_particle_create(_x, _y) {
	var _water = instance_create_depth(_x, _y, depth, obj_particle);
	_water.sprite_index = spr_water_particle;
	_water.image_index  = irandom(_water.image_number - 1);
	_water.image_speed  = 0;
	_water.xscale		= random_range(1.0, 1.4);
	_water.yscale		= _water.xscale;
	_water.z			= z - sprite_height;
	_water.height		= 100;	
}
	
/// @function fire_particle_create(x, y, z)
function fire_particle_create(_x, _y, _z) {
	var _offset = UNIT_SIZE * 0.25;
	var _fire = instance_create_depth(_x + irandom_range(-_offset, _offset), _y + irandom_range(-_offset, _offset), depth, obj_float_particle);
	_fire.sprite_index = spr_fire_particle;
	_fire.image_index  = irandom(_fire.image_number - 1);
	_fire.image_speed  = 0;
	_fire.xscale		= random_range(0.6, 1.0);
	_fire.yscale		= _fire.xscale;
	_fire.z				= _z;
	_fire.iter_speed	= 1;
	_fire.height		= 200;
}

/// @function wood_particle_create(x, y)
function wood_particle_create(_x, _y) {
	var _offset = UNIT_SIZE * 0.25;
	
	var _wood = instance_create_depth(_x + random_range(-_offset, _offset), _y + random_range(-_offset, _offset), depth, obj_particle);
	_wood.sprite_index = spr_wood_particle;
	_wood.image_index  = irandom(_wood.image_number - 1);
	_wood.image_speed  = 0;
	_wood.xscale		= random_range(1.0, 1.4);
	_wood.yscale		= _wood.xscale;
	_wood.z				= z - sprite_height;
	_wood.height		= 100;	
}

























