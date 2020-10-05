event_inherited();

z = -1;

model = new Model_Instance(global.ramp_model);
model.scale(SCALE_3D + 10);
model.x = x;
model.y = y;
model.z = z;
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
	audio_play_sound(sfx_wood, 0, false);
}