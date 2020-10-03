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
    draw_sprite(_sprite, _subimage, 0, 0);
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
	ds_grid_clear(GRID_LIGHTS, 0);
	ds_grid_clear(GRID_CARS, 0);		
	ds_grid_clear(GRID_HUMANS, 0);		
}

/// @function resize_grids(width, height)
function resize_grids(_width, _height) {
	ds_grid_resize(GRID_ENVIRONMENT, _width, _height);
	ds_grid_resize(GRID_LIGHTS,		 _width, _height);
	ds_grid_resize(GRID_CARS,		 _width, _height);
	ds_grid_resize(GRID_HUMANS,		 _width, _height);
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

/// @function grid_check_for(grid, u, v, dir, dist, enum)
function grid_check_for(_grid, _u, _v, _dir, _dist, _enum) {
	var _i = undefined;
	var _j = undefined;
	
	switch (_dir) {
		case DIR.RIGHT:
			for (var i = _u; i < _u + _dist; i++) {
				if (_grid[# i, _v] == _enum) {
					_i =  i;
					_j = _v;
					break;
				}
			}
			break;
		case DIR.LEFT:
			for (var i = _u; i > _u - _dist; i++) {
				if (_grid[# i, _v] == _enum) {
					_i =  i;
					_j = _v;
					break;
				}
			}
			break;
		case DIR.UP:
			for (var j = _v; j > _v - _dist; j--) {
				if (_grid[# _u, j] == _enum) {
					_i = _u;
					_j =  j;
					break;
				}
			}
			break;
		case DIR.DOWN:
			for (var j = _v; j < _v + _dist; j++) {
				if (_grid[# _u, j] == _enum) {
					_i = _u;
					_j =  j;
					break;
				}
			}
			break;
	}
	return [_i, _j];
}