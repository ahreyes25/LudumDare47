if (show) {
	image_xscale = 1 + sin(scale_iter) * 0.1;
	image_yscale = 1 + sin(scale_iter) * 0.1;
	draw_sprite_billboard_cylinder(sprite_index, image_index, x, y, z + sin(z_iter) * 2);	
}