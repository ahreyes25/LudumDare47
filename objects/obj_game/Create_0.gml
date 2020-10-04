global_game_data();
dotobj_init();

instance_create_depth(0, 0, depth, obj_debug);
instance_create_depth(0, 0, depth, obj_camera);

room_goto_next();

global.street_model		= dotobj_model_load_file("Road.obj", true, true);
global.building_model	= dotobj_model_load_file("Building-1.obj", true, false);
