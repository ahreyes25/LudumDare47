event_inherited();

z = UNIT_SIZE * 0.75;

target_x = x;
target_y = y;
target_z = z;

model = new Model_Instance(global.cone_model);
model.scale(SCALE_3D + 10);
model.x = x;
model.y = y;
model.z = z;
entity = ENTITY.CONE;
facing = DIR.NONE;
moving = false;
stored = false;
action = undefined;
state  = "";

update_uvs();

do_crash	= function() {
	if (GRID_CRASHES[# u, v] == undefined)
		GRID_CRASHES[# u, v] = ds_list_create();
	ds_list_insert(GRID_CRASHES[# u, v], 0, id);
	state = "crash";
}