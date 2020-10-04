event_inherited();

z = -height_units * UNIT_SIZE;
target_z = z;

model = dotobj_model_load_file("Piano.obj", true, true);
model.scale(SCALE_3D + 5);
model.yscale += 5;
model.xangle = 150;
model.yangle = 225;
model.zangle = 80;
model.x = x;
model.y = y;
model.z = z;
ds_list_add(LIST_ENTITIES, id);

fall = function() {
	target_z = z + UNIT_SIZE;	
}

action = fall;
state  = "fall";