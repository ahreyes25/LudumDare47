global_game_data();
//dotobj_init();

instance_create_depth(0, 0, depth, obj_debug);
instance_create_depth(0, 0, depth, obj_camera);

room_goto_next();

entities		= ds_list_create();
action_interval	= 30;
act_on_entities	= function() {
	for (var i = 0; i < ds_list_size(entities); i++) {
		var _entity = entities[| i];
		if (instance_exists(_entity) && _entity.action != undefined)
			_entity.action();
	}	
}