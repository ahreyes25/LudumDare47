if (keyboard_check_pressed(vk_enter))
	obj_grid.act_on_entities();

if (instance_exists(obj_grid) && !instance_exists(obj_camera))
	instance_create_depth(x, y, depth, obj_camera);
	
SLOW_FACTOR = !keyboard_check(ord("U"));