var _gx		= obj_grid.center_x;
var _gy		= obj_grid.center_y;
var _gw		= obj_grid.grid_width  * UNIT_SIZE;
var _gh		= obj_grid.grid_height * UNIT_SIZE;

x			= _gx - _gw * 0.25;
y			= _gy + _gh * 0.60;
z			= -200;
xtarget		= x;
ytarget		= y;
ztarget		= z;
xto			= obj_grid.center_x;
yto			= obj_grid.center_y;
zto			= -50;
fov			= 60;

positions	= [
	[_gx - _gw * 0.60, _gy + _gh * 0.20, -300],
	[_gx - _gw * 0.50, _gy + _gh * 0.40, -250],
	[x, y, z],
	[_gx, y, -150],
	[_gx + _gw * 0.25, y, z],
	[_gx + _gw * 0.50, _gy + _gh * 0.40, -250],
	[_gx + _gw * 0.60, _gy + _gh * 0.20, -300],
];
position_index = 1;

// Only Used With First Person Or Third Person Camera
//look_dir	=  63;
//look_pitch	= -14;
move_speed	=  4;

look_first_person = function() {		
	//xto = x + dcos(look_dir) * dcos(look_pitch);
	//yto = y - dsin(look_dir) * dcos(look_pitch);
	//zto = z - dsin(look_pitch);
}
look_third_person = function() {	
	//var _third_person_distance = 160;
	//
	//x	= xto - _third_person_distance * dcos(look_dir) * dcos(look_pitch);
	//y	= yto + _third_person_distance * dsin(look_dir) * dcos(look_pitch);
	//z	= zto + _third_person_distance * dsin(look_pitch);
}
mouse_move_camera = function() {
	look_dir	-= (window_mouse_get_x() - (window_get_width()  / 2)) / 10;
	look_pitch	-= (window_mouse_get_y() - (window_get_height() / 2)) / 10;
	look_pitch   = (CAMERA_PERSPECTIVE == PERSPECTIVE.FIRST) ? clamp(look_pitch, -80, 80) : clamp(look_pitch, -80, 10);

	window_mouse_set(window_get_width() / 2, window_get_height() / 2);

	//if (keyboard_check(ord("A"))) {
	//    x -= dsin(look_dir) * move_speed;
	//    y -= dcos(look_dir) * move_speed;
	//}
	//
	//if (keyboard_check(ord("D"))) {
	//    x += dsin(look_dir) * move_speed;
	//    y += dcos(look_dir) * move_speed;
	//}
	//
	//if (keyboard_check(ord("W"))) {
	//    x += dcos(look_dir) * move_speed;
	//    y -= dsin(look_dir) * move_speed;
	//}
	//
	//if (keyboard_check(ord("S"))) {
	//    x -= dcos(look_dir) * move_speed;
	//    y += dsin(look_dir) * move_speed;
	//}
}

//model = dotobj_model_load_file("spaceShipHall3.obj", true, false);
//model.xscale = 100;
//model.yscale = 100;
//model.zscale = 100;
//model.z = -20;
//model.x = room_width / 2;
//model.y = room_height / 2;