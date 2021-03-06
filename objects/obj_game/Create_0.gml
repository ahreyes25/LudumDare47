randomize();
global_game_data();
dotobj_init();
draw_set_font(fnt_main);

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
global.cone_model			= dotobj_model_load_file("Traffic-Cone.obj", true, false);

// Game Logic 
in_main_menu			= true;
rounds_total			= 10000;
round_counter			= 0;
turn_counter			= 0;
turns_total				= 20;
inventory				= [obj_car,	obj_piano, obj_ramp, obj_cone];
inventory_show			= false;
inventory_y_target		= SH;
inventory_y				= inventory_y_target;
placed_item_this_round	= false;
frames_per_turn			= 35;
execute					= false;
space_cooldown			= frames_per_turn;
new_round_flicker		= false;
new_round_flicker_count	= 10;
new_round_flickering	= false;

car_colors				= ds_list_create();
cars_created			= 0;
for (var i = 0; i < 1000; i++) {
	ds_list_add(car_colors, choose(1, 2, 3));
}

player_actions			= ds_list_create();
recreate_actions		= function() {
	for (var i = 0; i < ds_list_size(player_actions); i++) {
		var _action_data   = player_actions[| i];
		var _turn_counter  = _action_data[0];
		var _round_counter = _action_data[7];
		
		if (turn_counter == _turn_counter && round_counter != _round_counter) {
			var _object_index	= _action_data[1];
			var _object_u		= _action_data[2];
			var _object_v		= _action_data[3];
			var _object_x		= _action_data[4];
			var _object_y		= _action_data[5];
			var _object_z		= _action_data[6];
			var _object_facing	= _action_data[8];
			
			var _inst		= instance_create_depth(_object_x, _object_y, depth, _object_index);
			_inst.u			= _object_u;
			_inst.v			= _object_v;
			_inst.z			= _object_z;
			_inst.target_x	= _object_x;
			_inst.target_y	= _object_y;
			_inst.target_z	= _object_z;
			_inst.facing	= _object_facing;
		}
	}	
}

global.music_emitter_happy		= audio_emitter_create();
global.music_emitter_intense	= audio_emitter_create();
#macro MUSIC_EMITTER_HAPPY		global.music_emitter_happy 
#macro MUSIC_EMITTER_INTENSE	global.music_emitter_intense

audio_emitter_gain(MUSIC_EMITTER_HAPPY, 1.0);
audio_emitter_gain(MUSIC_EMITTER_INTENSE, 0.0);
audio_play_sound_on(MUSIC_EMITTER_HAPPY, music_happy, true, 0);
audio_play_sound_on(MUSIC_EMITTER_INTENSE, music_intense_2, true, 0);
water_inst_1 = undefined;
water_inst_2 = undefined;
water_inst_3 = undefined;

game_won = false;
objectives_index = 0;
volume_index = 1;
if (volume_index == 3)
	audio_master_gain(1);
else if (volume_index == 2)
	audio_master_gain(0.5);
else if (volume_index == 1)
	audio_master_gain(0.25);
else if (volume_index == 0)
	audio_master_gain(0);