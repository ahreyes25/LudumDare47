check_to_place_piece();

var _left_pressed	= !keyboard_check(vk_shift) && keyboard_check_pressed(ord("A"));
var _right_pressed	= !keyboard_check(vk_shift) && keyboard_check_pressed(ord("D"));
var _up_pressed		= !keyboard_check(vk_shift) && keyboard_check_pressed(ord("W"));
var _down_pressed	= !keyboard_check(vk_shift) && keyboard_check_pressed(ord("S"));

if (obj_camera.position_index <= 1) {
	if (_left_pressed)	move(1, DIR.UP);
	if (_right_pressed) move(1, DIR.DOWN);
	if (_up_pressed)	move(1, DIR.RIGHT);
	if (_down_pressed)	move(1, DIR.LEFT);
}
else if (obj_camera.position_index >= array_length(obj_camera.positions) - 2) {
	if (_left_pressed)	move(1, DIR.DOWN);
	if (_right_pressed) move(1, DIR.UP);
	if (_up_pressed)	move(1, DIR.LEFT);
	if (_down_pressed)	move(1, DIR.RIGHT);
}
else {
	if (_left_pressed)	move(1, DIR.LEFT);
	if (_right_pressed) move(1, DIR.RIGHT);
	if (_up_pressed)	move(1, DIR.UP);
	if (_down_pressed)	move(1, DIR.DOWN);
}

if (selected_object != undefined) {
	var _coords = grid_to_world(u, v);
	//selected_object.x = _coords[0];
	//selected_object.y = _coords[1];
}
depth = obj_camera.depth - 1;