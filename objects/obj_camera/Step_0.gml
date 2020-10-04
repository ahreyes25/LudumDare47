//if (!SHOW_2D)
	//mouse_move_camera();

xtarget = positions[position_index][0];
ytarget = positions[position_index][1];
ztarget = positions[position_index][2];

x = lerp(x, xtarget, 0.1);
y = lerp(y, ytarget, 0.1);
z = lerp(z, ztarget, 0.1);

depth = -10;

if (keyboard_check_pressed(vk_right)) {
	if (position_index < array_length(positions) - 1)
		position_index++;
}
if (keyboard_check_pressed(vk_left)) {
	if (position_index > 0)
		position_index--;
}
//if (keyboard_check_pressed(ord("3")))	position_index = 2;