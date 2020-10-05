show			= false;
z_base			= 1;
z				= z_base;
u				= undefined;
v				= undefined;
depth			= 0;
selected_object	= undefined;
xtarget			= x;
ytarget			= y;
ztarget			= z;

z_iter				= 0;
z_iter_speed		= 0.02;
scale_iter			= 0;
scale_iter_speed	= 0.05;

move		= function(_amount, _dir) {
	switch (_dir) {
		case DIR.RIGHT:	
			xtarget += UNIT_SIZE * _amount;
			u += _amount;
			
			if (selected_object != undefined)
				selected_object.target_x += UNIT_SIZE * _amount;
			break;
			
		case DIR.LEFT:	
			xtarget -= UNIT_SIZE * _amount;	
			u -= _amount;
			
			if (selected_object != undefined)
				selected_object.target_x -= UNIT_SIZE * _amount;
			break;
			
		case DIR.UP:	
			ytarget -= UNIT_SIZE * _amount;	
			v -= _amount;
			
			if (selected_object != undefined)
				selected_object.target_y -= UNIT_SIZE * _amount;
			break;
			
		case DIR.DOWN:	
			ytarget += UNIT_SIZE * _amount;	
			v += _amount;
			
			if (selected_object != undefined)
				selected_object.target_y += UNIT_SIZE * _amount;
			break;
	}
}
update_uvs	= function() {
	var _coords = world_to_grid(x, y);
	u = _coords[0];
	v = _coords[1];
}
center		= function() {
	u = obj_grid.grid_width  div 2;
	v = obj_grid.grid_height div 2;
	var _coords = grid_to_world(u, v);
	x = _coords[0] + UNIT_SIZE * 0.5;
	y = _coords[1] + UNIT_SIZE * 0.5;
	z = z_base;
	xtarget = x;
	ytarget = y;
	ztarget = z;
}
clear_selected = function() {
	if (selected_object != undefined) {
		instance_destroy(selected_object);
		selected_object = undefined;
	}
}


	
update_uvs();