if (busted && SLOW_FACTOR != 0)
	water_particle_create(x, y);

if (keyboard_check_pressed(ord("B")))
	busted = !busted;