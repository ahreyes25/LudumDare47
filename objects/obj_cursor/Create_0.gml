show			= true;
z				= 3;
u				= undefined;
v				= undefined;
depth			= 0;
selected_object	= undefined;

z_iter				= 0;
z_iter_speed		= 0.02;
scale_iter			= 0;
scale_iter_speed	= 0.05;

move					= function(_amount, _dir) {
	switch (_dir) {
		case DIR.RIGHT:	
			x += UNIT_SIZE * _amount;
			u += _amount;
			break;
			
		case DIR.LEFT:	
			x -= UNIT_SIZE * _amount;	
			u -= _amount;
			break;
			
		case DIR.UP:	
			y -= UNIT_SIZE * _amount;	
			v -= _amount;
			break;
			
		case DIR.DOWN:	
			y += UNIT_SIZE * _amount;	
			v += _amount;
			break;
	}
}
check_to_place_piece	= function() {
	if (keyboard_check_pressed(vk_space) && selected_object == undefined) {
		var _u = irandom(obj_grid.grid_width  - 1);
		var _v = irandom(obj_grid.grid_height - 1);
		var _coords = grid_to_world(_u, _v);
		selected_object = instance_create_depth(_coords[0] + UNIT_SIZE / 2, _coords[1] + UNIT_SIZE / 2, depth, obj_car);
		selected_object.z = -1;
	}
	else if (keyboard_check_pressed(vk_space) && selected_object != undefined)
		selected_object = undefined;
}
update_uvs				= function() {
	var _coords = world_to_grid(x, y);
	u = _coords[0];
	v = _coords[1];
}
	
update_uvs();