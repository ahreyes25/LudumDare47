event_inherited();

switch (facing) {
	case DIR.LEFT:	model.zangle = 0;	model.zangle_target = 0;	break;	
	case DIR.RIGHT:	model.zangle = 180;	model.zangle_target = 180;	break;	
	case DIR.UP:	model.zangle = 270;	model.zangle_target = 270;	break;	
	case DIR.DOWN:	model.zangle = 90;	model.zangle_target = 90;	break;	
}

model.x = x;
model.y = y;
model.z = z;
model.update();

// Store Ramp Into Car Grid
if (!moving && !stored) {
	GRID_CARS[# u, v] = ENTITY.RAMP;
	stored = true;
}

if (alarm0 != -1 && SLOW_FACTOR != 0) {
	if (irandom(1) == 0)
		wood_particle_create(x, y);
}