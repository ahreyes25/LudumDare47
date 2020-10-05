event_inherited();

model.x = x;
model.y = y;
model.z = z;
model.update();

if (!moving && !stored) {
	store_in_grid();
	stored = true;
}