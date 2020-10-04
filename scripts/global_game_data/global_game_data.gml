enum PERSPECTIVE { FIRST, THIRD, NONE }
enum DIR { LEFT = -1, RIGHT = 1, UP, DOWN, NONE }
enum ENVIRONMENT { SIDEWALK, ROAD, BUILDING, GRASS, PARKING_LOT, TURNING_LANE, CROSS_WALK }
enum ENTITY { CAR, CHAR, STOPLIGHT, NONE }
enum CAR { BASIC, NONE }
enum CHAR { GUY_BASIC, GIRL_BASIC, GUY_SPORTS, GIRL_SPORTS, MAILMAN, DOG, NONE }
enum LIGHT { BASIC, NONE }

display_reset(8, true);

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_tex_repeat(true);

// Turn Off For Performance Improvement
//gpu_set_tex_mip_enable(mip_on);
//gpu_set_tex_mip_filter(tf_anisotropic);
//gpu_set_tex_max_aniso(16);

global.camera_perspective	= PERSPECTIVE.FIRST;
global.unit_size			= 24;
#macro CAMERA_PERSPECTIVE	global.camera_perspective
#macro UNIT_SIZE			global.unit_size

global.list_entities		= ds_list_create();
global.grid_environment		= ds_grid_create(1, 1);
global.grid_lights			= ds_grid_create(1, 1);
global.grid_cars			= ds_grid_create(1, 1);
global.grid_chars			= ds_grid_create(1, 1);
global.grid_crashes			= ds_grid_create(1, 1);
#macro LIST_ENTITIES		global.list_entities
#macro GRID_ENVIRONMENT		global.grid_environment
#macro GRID_LIGHTS			global.grid_lights
#macro GRID_CARS			global.grid_cars
#macro GRID_CHARS			global.grid_chars
#macro GRID_CRASHES			global.grid_crashes

global.scale_3d				= 20;
global.show_2d				= false;
#macro SCALE_3D				global.scale_3d
#macro SHOW_2D				global.show_2d

global.slow_factor			= 1;
#macro SLOW_FACTOR			global.slow_factor

global.crash_color			= c_black;
#macro CRASH_COLOR			global.crash_color