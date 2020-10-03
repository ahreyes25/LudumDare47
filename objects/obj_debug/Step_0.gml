if (keyboard_check_pressed(ord("R")))	room_restart();

if (keyboard_check_pressed(ord("1")))	structure_index = 0;
if (keyboard_check_pressed(ord("2")))	structure_index = 1;
if (keyboard_check_pressed(ord("3")))	structure_index = 2;
if (keyboard_check_pressed(ord("4")))	structure_index = 3;
if (keyboard_check_pressed(ord("5")))	structure_index = 4;
if (keyboard_check_pressed(vk_tab))		structures_show = !structures_show;