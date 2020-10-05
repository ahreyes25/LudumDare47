// Update UVs and Store Into Grid
var _coords = world_to_grid(x, y);
u = _coords[0];
v = _coords[1];
var _grid = grid_get_grid(entity);
if (_grid != undefined && grid_in_bounds(_grid, u, v))
	_grid[# u, v] = entity;