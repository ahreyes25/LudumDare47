if (SHOW_2D) {
	draw_self();	
	draw_text(x, y, state);
	draw_text(x, y + 10, "u: " + string(u) + ", v: " + string(v));
}
if (status_sprite != undefined && show) {
	image_alpha = 0.75;
	
	var _status_sprite = status_sprite != undefined ? sprite_get_name(status_sprite) : "undefined";
	
	// Draw Arrow In World
	if (status_sprite == spr_status_arrow) {
		var _x = x;
		var _y = y;
		switch (facing) {
			case DIR.LEFT:	image_angle = 180;	_x -= UNIT_SIZE * 0.75; break;
			case DIR.RIGHT:	image_angle = 0;	_x += UNIT_SIZE * 0.75; break;
			case DIR.UP:	image_angle = 90;	_y -= UNIT_SIZE * 0.75; break;
			case DIR.DOWN:	image_angle = 270;	_y += UNIT_SIZE * 0.75; break; 
		}
		visible = true;
		draw_sprite_billboard_cylinder(status_sprite, 0, _x, _y, z + 6);
	}
	// Draw Status Icon Above
	else if (status_sprite != undefined) {
		image_angle = 0;
		visible = false;
		draw_sprite_billboard_cylinder(status_sprite, 0, x, y, z - UNIT_SIZE);
	}
}