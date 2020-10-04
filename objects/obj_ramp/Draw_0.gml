if (SHOW_2D) {
	switch (facing) {
		case DIR.LEFT:	image_angle = 180;	break;	
		case DIR.RIGHT: image_angle = 0;	break;	
		case DIR.UP:	image_angle = 90;	break;	
		case DIR.DOWN:	image_angle = 270;	break;	
	}
	draw_self();
	draw_text(x, y, z);
}