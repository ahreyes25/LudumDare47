event_inherited();

entity				= ENTITY.STOPLIGHT;
light_time_green	= 7;
light_time_yellow	= 3;
light_time_red		= light_time_green + light_time_yellow;
action				= undefined;

if (light == "green")		light_count	= light_time_green;
else if (light == "yellow")	light_count	= light_time_yellow;
else if (light == "red")	light_count	= light_time_red;

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