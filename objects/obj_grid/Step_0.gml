center_x = x + (grid_width  * UNIT_SIZE / 2);
center_y = y + (grid_height * UNIT_SIZE / 2);

if (world_3d == undefined) 
	world_3d = instance_create_depth(center_x, center_y, depth, obj_world_3D);