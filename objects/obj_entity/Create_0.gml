entity	= undefined;
u_curr	= undefined;
v_curr	= undefined;
u_past	= undefined;
v_past	= undefined;

/// Functions
update_uv = function() {
	var _coords = world_to_grid(x, y);
	var _u		= _coords[0];
	var _v		= _coords[1];
	//obj_grid.entities_grid[# _u, _v] = entity;
	
	if (_u != u_curr)	u_past =  u_curr;
	if (_u != u_past)	u_curr = _u;
	if (_v != v_curr)	v_past =  v_curr;
	if (_v != v_past)	v_curr = _v;
}	