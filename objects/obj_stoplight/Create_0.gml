event_inherited();

entity				= ENTITY.STOPLIGHT;
light				= "green";
light_time_green	= 10;
light_time_red		= light_time_green;
light_time_yellow	= 3;
light_count			= 6;
action				= undefined;

update_uvs();
store_in_grid();

// functions
change_light	= function() {
	if (light == "green") {
		light = "yellow";
		light_count = light_time_yellow;
	}
	else if (light == "yellow") {
		light = "red";
		light_count = light_time_red;
	}
	else {
		light = "green";
		light_count = light_time_green;
	}
}
countdown		= function() {
	light_count--;
	if (light_count <= 0)
		change_light();
}
action			= countdown;