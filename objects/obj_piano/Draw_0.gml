if (SHOW_2D) {
	draw_self();
	draw_text(x, y, z);
}

if (state == "fall")
	draw_sprite_billboard_cylinder(spr_fall_streaks, 0, x, y, z - UNIT_SIZE * 0.5);