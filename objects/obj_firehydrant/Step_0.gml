if (busted)	{
	var _water = instance_create_depth(x, y, depth, obj_particle);
	_water.sprite_index = spr_water_particle;
	_water.image_index  = choose(0, 1);
	_water.image_speed  = 0;
}

if (keyboard_check_pressed(ord("B")))
	busted = !busted;