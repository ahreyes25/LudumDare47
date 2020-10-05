if (live_call()) return live_result;

if (selected_object != undefined) {
	if (selected_object.object_index == obj_piano)
		ztarget = selected_object.z;
	else
		ztarget = z_base;
}
show = selected_object != undefined;

x = lerp(x, xtarget, 0.1);
y = lerp(y, ytarget, 0.1);
z = lerp(z, ztarget, 0.1);

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

//aif (selected_object != undefined) {
//a	var _coords = grid_to_world(u, v);
//a	
//a	selected_object.x = _coords[0];
//a	selected_object.y = _coords[1];
//a	show_debug_message("item u: " + string(selected_object.u) + ", v: " + string(selected_object.v));
//a	show_debug_message("item x: " + string(selected_object.x) + ", y: " + string(selected_object.y));
//a}
depth = obj_camera.depth - 1;

show_debug_message("cursor u: " + string(u) + ", v: " + string(v));
show_debug_message("cursor x: " + string(x) + ", y: " + string(y));