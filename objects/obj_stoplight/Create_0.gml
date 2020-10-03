var _coords			= world_to_grid(x, y);
u_curr				= _coords[0];
v_curr				= _coords[1];
light				= "green";
light_time_green	= 10;
light_time_red		= light_time_green;
light_time_yellow	= 3;
light_count			= 6;

action				= undefined;
ds_list_add(LIST_ENTITIES, id);

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