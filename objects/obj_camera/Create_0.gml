x	= room_width;
y	= room_height;
z	= 400;
xto	= 0;
yto	= 0;
zto	= 0;
fov	= 60;

look_first_person = function() {
	if (!instance_exists(obj_player)) return;
		
	x	= obj_player.x;
	y	= obj_player.y;
	z	= obj_player.z;
	xto = x + dcos(obj_player.look_dir) * dcos(obj_player.look_pitch);
	yto = y - dsin(obj_player.look_dir) * dcos(obj_player.look_pitch);
	zto = z - dsin(obj_player.look_pitch);
}
look_third_person = function() {
	if (!instance_exists(obj_player)) return;
	
	var _third_person_distance = 160;
	
	xto = obj_player.x;
	yto = obj_player.y;
	zto = obj_player.z;
	x	= xto - _third_person_distance * dcos(obj_player.look_dir) * dcos(obj_player.look_pitch);
	y	= yto + _third_person_distance * dsin(obj_player.look_dir) * dcos(obj_player.look_pitch);
	z	= zto + _third_person_distance * dsin(obj_player.look_pitch);
}

model = dotobj_model_load_file("spaceShipHall3.obj", true, false);
model.xscale = 100;
model.yscale = 100;
model.zscale = 100;
model.z = -20;
model.x = room_width / 2;
model.y = room_height / 2;