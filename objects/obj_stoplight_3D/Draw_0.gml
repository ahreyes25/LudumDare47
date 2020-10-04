draw_self();

if (stoplight != undefined && instance_exists(stoplight)) {
	if (stoplight.light == "green")
		draw_sprite_billboard_cylinder(spr_stoplight_lights, 2, x, y, z - 40);	
	else if (stoplight.light == "yellow")
		draw_sprite_billboard_cylinder(spr_stoplight_lights, 1, x, y, z - 40);	
	else
		draw_sprite_billboard_cylinder(spr_stoplight_lights, 0, x, y, z - 40);	
}