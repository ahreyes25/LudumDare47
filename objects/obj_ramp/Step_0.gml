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