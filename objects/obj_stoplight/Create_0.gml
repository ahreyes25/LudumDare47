light			= "green";
time_green		= room_speed * 4;
time_yellow		= room_speed * 2;
time_red		= time_green;

change_light	= function() {
	if (light == "green")
		light = "yellow";
	else if (light == "yellow")
		light = "red";
	else
		light = "green";
}
get_time		= function() {
	if (light == "green")
		return time_green;
	else if (light == "yellow")
		return time_yellow;
	else if (light == "red")
		return time_red;
}

alarm[0]		= get_time();