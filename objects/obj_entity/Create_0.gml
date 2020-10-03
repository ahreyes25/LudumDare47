entity	= undefined;
u_curr	= undefined;
v_curr	= undefined;
u_past	= undefined;
v_past	= undefined;

ds_list_add(obj_game.entities, id);

/// Functions
left_free_of_entity		= function() {
	var _coords = world_to_grid(x, y);
	var _u		= _coords[0] - 1;
	var _v		= _coords[1];
	return obj_grid.entities_grid[# _u, _v] == ENTITY.NONE;
}
right_free_of_entity	= function() {
	var _coords = world_to_grid(x, y);
	var _u		= _coords[0] + 1;
	var _v		= _coords[1];
	return obj_grid.entities_grid[# _u, _v] == ENTITY.NONE;
}
up_free_of_entity		= function() {
	var _coords = world_to_grid(x, y);
	var _u		= _coords[0];
	var _v		= _coords[1] - 1;
	return obj_grid.entities_grid[# _u, _v] == ENTITY.NONE;
}
down_free_of_entity		= function() {
	var _coords = world_to_grid(x, y);
	var _u		= _coords[0];
	var _v		= _coords[1] + 1;
	return obj_grid.entities_grid[# _u, _v] == ENTITY.NONE;
}
left_environment		= function() {
	var _coords = world_to_grid(x, y);
	var _u		= _coords[0] - 1;
	var _v		= _coords[1];
	return obj_grid.environment_grid[# _u, _v];
}
right_environment		= function() {
	var _coords = world_to_grid(x, y);
	var _u		= _coords[0] + 1;
	var _v		= _coords[1];
	return obj_grid.environment_grid[# _u, _v];
}
up_environment			= function() {
	var _coords = world_to_grid(x, y);
	var _u		= _coords[0];
	var _v		= _coords[1] - 1;
	return obj_grid.environment_grid[# _u, _v];
}
down_environment		= function() {
	var _coords = world_to_grid(x, y);
	var _u		= _coords[0];
	var _v		= _coords[1] + 1;
	return obj_grid.environment_grid[# _u, _v];
}
update_uv				= function() {
	var _coords = world_to_grid(x, y);
	var _u		= _coords[0];
	var _v		= _coords[1];
	obj_grid.entities_grid[# _u, _v] = entity;
	
	if (_u != u_curr)	u_past =  u_curr;
	if (_u != u_past)	u_curr = _u;
	if (_v != v_curr)	v_past =  v_curr;
	if (_v != v_past)	v_curr = _v;
}	