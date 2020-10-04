event_inherited();

model.x = x;
model.y = y;

switch (facing) {
	case DIR.RIGHT:	model.zangle = 180;	break;
	case DIR.LEFT:	model.zangle = 0;	break;
	case DIR.UP:	model.zangle = 270;	break;
	case DIR.DOWN:	model.zangle = 90;	break;
}

// Check For Car Crash
if (abs(x - target_x) <= 0.1 && abs(y - target_y) <= 0.1) {
	var _car = collision_circle(x, y, 5, obj_car, false, true);
	if (_car != undefined && _car != noone) {
		action = undefined;
		state  = "crash";
	}
}