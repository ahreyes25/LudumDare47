event_inherited();

z = -1;

model = dotobj_model_load_file("Ramp.obj", true, false);
model.scale(SCALE_3D + 10);
model.x = x;
model.y = y;
model.z = z;
//model.xscale += 10;
//model.zscale += 10;
//model.yscale += 10;
update_uvs();
entity	= ENTITY.RAMP;
moving	= false;
stored	= false;
state	= "";
alarm0	= -1;

do_crash	= function() {
	if (GRID_CRASHES[# u, v] == undefined)
		GRID_CRASHES[# u, v] = ds_list_create();
	ds_list_insert(GRID_CRASHES[# u, v], 0, id);
	state = "crash";
	
	alarm0 = 30;
}