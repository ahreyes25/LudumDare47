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
update_uvs();
alarm0 = -1;

fall	 = function() {
	target_z = z + UNIT_SIZE;	
}
do_crash = function() {
	action = undefined;
	state  = "crash";
		
	if (GRID_CRASHES[# u, v] == undefined)
		GRID_CRASHES[# u, v] = ds_list_create();
	var _zoffset = ds_list_size(GRID_CRASHES[# u, v]);
	ds_list_add(GRID_CRASHES[# u, v], id);
		
	model.xangle_target = random_range(-90, 90);
	model.zangle_target = random_range(-90, 90);
	target_z = -_zoffset * UNIT_SIZE * 0.5;	
	alarm0 = 30;
}
	
action = fall;
state  = "fall";

model.xangle_target = 45;
model.yangle_target = 45;
model.zangle_target = 45;