//if (!SHOW_2D)
	mouse_move_camera();

if (instance_exists(obj_grid)) {
	x	 = obj_grid.x + obj_grid.grid_width  * UNIT_SIZE / 2;
	y	 = obj_grid.y + obj_grid.grid_height * UNIT_SIZE;
	xto	 = x;
	yto	 = obj_grid.y + obj_grid.grid_height * UNIT_SIZE / 2;
}