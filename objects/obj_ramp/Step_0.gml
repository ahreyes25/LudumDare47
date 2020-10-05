event_inherited();

model.x = x;
model.y = y;
model.z = z;
model.update();

// Store Ramp Into Car Grid
if (!moving && !stored) {
	GRID_CARS[# u, v] = ENTITY.RAMP;
	stored = true;
}

if (alarm[0] != -1) {
	if (irandom(1) == 0)
		wood_particle_create(x, y);
}