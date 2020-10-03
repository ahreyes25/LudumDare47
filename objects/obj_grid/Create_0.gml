x = 100;
y = 100;

grid_width	= 25;
grid_height	= 25;
unit_size	= 16;
grid		= ds_grid_create(grid_width, grid_height);
mp_grid		= mp_grid_create(x, y, grid_width, grid_height, unit_size, unit_size);

draw_grid	= function() {
	for (var i = 0; i <= grid_width; i++)
		draw_line(x + i * unit_size, y, x + i * unit_size, y + grid_height * unit_size);
	for (var j = 0; j <= grid_height; j++)
		draw_line(x, y + j * unit_size, x + grid_width * unit_size, y + j * unit_size);	
}