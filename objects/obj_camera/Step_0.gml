//if (!SHOW_2D)
	//mouse_move_camera();
	
if (obj_game.in_main_menu) {
	if (!panning) {
		position_index += pan_dir;
		pan_dir *= -1;
		panning = true;
	}
	else {
		var _x = (abs(x - xtarget) <= 10);
		var _y = (abs(y - ytarget) <= 10);
		var _z = (abs(z - ztarget) <= 10);
		if (_x && _y && _z)
			panning = false;
	}
}

xtarget = positions[position_index][0];
ytarget = positions[position_index][1];
ztarget = positions[position_index][2];

if (position_index == 0 || position_index == array_length(positions) - 1)
	var _lerp_speed = 0.02;
else
	var _lerp_speed = 0.05;

if (panning)
	_lerp_speed = 0.003;
	
x = lerp(x, xtarget, _lerp_speed);
y = lerp(y, ytarget, _lerp_speed);
z = lerp(z, ztarget, _lerp_speed);

depth = -10;

if (keyboard_check_pressed(ord("1"))) 	position_index = 0;
if (keyboard_check_pressed(ord("2"))) 	position_index = 1;
if (keyboard_check_pressed(ord("3"))) 	position_index = 2;
if (keyboard_check_pressed(ord("4"))) 	position_index = 3;
if (keyboard_check_pressed(ord("5"))) 	position_index = 4;
if (keyboard_check_pressed(ord("6"))) 	position_index = 5;
if (keyboard_check_pressed(ord("7")))	position_index = 6;
if (keyboard_check_pressed(ord("8")))	position_index = 7;

if (keyboard_check(vk_shift) && !panning) {
	if (keyboard_check_pressed(ord("D"))) {
		if (position_index < array_length(positions) - 1)
			position_index++;
	}
	if (keyboard_check_pressed(ord("A"))) {
		if (position_index > 0)
			position_index--;
	}	
}

// Inventory
