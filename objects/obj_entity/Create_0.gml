entity		= undefined;
u			= undefined;
v			= undefined;
z			= 0;
target_x	= x;
target_y	= y;
show		= true;

move			= function(_amount, _dir) {
	var _instant = argument_count == 3 ? argument[2] : false;
	
	var _grid			= grid_get_grid(entity);
	var _empty_value	= grid_get_empty_value(entity);
	
	switch (_dir) {
		case DIR.RIGHT:
			_grid[# u, v] = _empty_value;
			if (_instant) {
				x += UNIT_SIZE * _amount;	
				target_x = x;
			}
			else
				target_x += UNIT_SIZE * _amount;	
			u += _amount;
			_grid[# u, v] = entity;
			break;
			
		case DIR.LEFT:	
			_grid[# u, v] = _empty_value;
			if (_instant) {
				x -= UNIT_SIZE * _amount;
				target_x = x;
			}
			else
				target_x -= UNIT_SIZE * _amount;
			u -= _amount;
			_grid[# u, v] = entity;
			break;
			
		case DIR.UP:	
			_grid[# u, v] = _empty_value;
			if (_instant) {
				y -= UNIT_SIZE * _amount;	
				target_y = y;
			}
			else
				target_y -= UNIT_SIZE * _amount;	
			v -= _amount;
			_grid[# u, v] = entity;
			break;
			
		case DIR.DOWN:	
			_grid[# u, v] = _empty_value;
			if (_instant) {
				y += UNIT_SIZE * _amount;	
				target_y = y;
			}
			else
				target_y += UNIT_SIZE * _amount;	
			v += _amount;
			_grid[# u, v] = entity;
			break;
	}
}
update_uvs		= function() {
	var _coords = world_to_grid(x, y);
	u = _coords[0];
	v = _coords[1];
}
clear_from_grid = function() {
	if (u == undefined || v == undefined) return;
	var _grid			= grid_get_grid(entity);
	var _empty_value	= grid_get_empty_value(entity);
	
	_grid[# u, v] = _clear_value;
}
store_in_grid	= function() {
	var _grid = grid_get_grid(entity);
	_grid[# u, v] = entity;
}
	