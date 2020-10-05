randomize();
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
global.water_tower_model	= dotobj_model_load_file("Water-Tower.obj", true, false);
global.hill_model			= dotobj_model_load_file("Grass-Hill.obj", true, false);

// Game Logic
in_main_menu	= false;
rounds_total	= 4;
round_counter	= 0;
turn_counter	= 0;
turns_total		= 10;

frames_per_turn	= 30;
execute			= false;