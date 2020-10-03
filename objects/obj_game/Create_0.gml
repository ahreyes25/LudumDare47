enum PERSPECTIVE { FIRST, THIRD, NONE }

global_game_data();
//dotobj_init();

instance_create_depth(0, 0, depth, obj_debug);
instance_create_depth(0, 0, depth, obj_camera);

room_goto_next();