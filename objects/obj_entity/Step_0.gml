x = lerp(x, target_x, 0.1);
y = lerp(y, target_y, 0.1);
z = lerp(z, target_z, 0.1);

if (!grid_in_bounds(GRID_ENVIRONMENT, u, v))
	instance_destroy();