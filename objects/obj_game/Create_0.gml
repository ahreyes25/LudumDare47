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
global.car1_model			= dotobj_model_load_file("Car-1.obj", true, true);
global.car2_model			= dotobj_model_load_file("Car-2.obj", true, true);
global.car3_model			= dotobj_model_load_file("Car-3.obj", true, true);
global.stoplight_model		= dotobj_model_load_file("Traffic-Signal.obj", true, true);
global.ramp_model			= dotobj_model_load_file("Ramp.obj", true, false);
global.dead_tree_model		= dotobj_model_load_file("Tree-Dead.obj", false, true);
global.piano_model			= dotobj_model_load_file("Piano.obj", true, true);

// Game Logic 
in_main_menu			= false;
rounds_total			= 10000;
round_counter			= 0;
turn_counter			= 0;
turns_total				= 10;
inventory				= [obj_car,	obj_piano, obj_ramp, obj_char];
inventory_show			= false;
inventory_y_target		= SH;
inventory_y				= inventory_y_target;
placed_item_this_round	= false;
frames_per_turn			= 35;
execute					= false;
space_cooldown			= frames_per_turn;

car_colors				= ds_list_create();
cars_created			= 0;
for (var i = 0; i < 1000; i++)
	ds_list_add(car_colors, choose(1, 2, 3));









