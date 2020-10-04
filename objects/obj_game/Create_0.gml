global_game_data();
dotobj_init();

instance_create_depth(0, 0, depth, obj_debug);
//instance_create_depth(0, 0, depth, obj_camera);

room_goto_next();

global.street_model			= dotobj_model_load_file("Road.obj", true, false);
global.building_model		= dotobj_model_load_file("Building-1.obj", true, false);
global.building2_model		= dotobj_model_load_file("Building-2.obj", true, false);
global.parking_lot_model	= dotobj_model_load_file("ParkingLot.obj", false, false);
global.base_model			= dotobj_model_load_file("Island-Base.obj", true, false);
