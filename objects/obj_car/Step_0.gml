event_inherited();

model.x = x;
model.y = y;

switch (facing) {
	case DIR.RIGHT:	model.zangle = 180;	break;
	case DIR.LEFT:	model.zangle = 0;	break;
	case DIR.UP:	model.zangle = 270;	break;
	case DIR.DOWN:	model.zangle = 90;	break;
}