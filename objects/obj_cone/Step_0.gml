event_inherited();

model.x = x;
model.y = y;
model.z = z;
model.update();

if (!moving && !stored) {
	update_uvs();
	GRID_CONES[# u, v] = CONE.BASIC;
	stored = true;
}