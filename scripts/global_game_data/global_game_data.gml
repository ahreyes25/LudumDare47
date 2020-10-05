enum PERSPECTIVE { FIRST, THIRD, NONE }
enum DIR { LEFT = -1, RIGHT = 1, UP, DOWN, NONE }
enum ENVIRONMENT { SIDEWALK, ROAD, BUILDING, GRASS, PARKING_LOT, TURNING_LANE, CROSS_WALK }
enum ENTITY { CAR, CHAR, STOPLIGHT, RAMP, NONE }
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

global.sw = surface_get_width(application_surface);
global.sh = surface_get_height(application_surface);
#macro SW global.sw
#macro SH global.sh

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

function Model_Instance(_model_struct) constructor {
	group_map		= _model_struct.group_map;
	group_list		= _model_struct.group_list;
	x				= _model_struct.x;
	y				= _model_struct.y;
	z				= _model_struct.z;
	xangle			= _model_struct.xangle;
	yangle			= _model_struct.yangle;
	zangle			= _model_struct.zangle;
	xscale			= _model_struct.xscale;
	yscale			= _model_struct.yscale;
	zscale			= _model_struct.zscale;
	xangle_target	= _model_struct.xangle_target;
	yangle_target	= _model_struct.yangle_target;
	zangle_target	= _model_struct.zangle_target;
	
	submit			= function() {
		var _g = 0;
		matrix_set(matrix_world, matrix_build(x, y, z, xangle, yangle, zangle, xscale, yscale, zscale));
        repeat (ds_list_size(group_list)) {
            group_map[? group_list[| _g]].submit();
            ++_g;
        }
		matrix_set(matrix_world, matrix_build_identity());	
	}
	update			= function() {
		xangle = lerp(xangle, xangle_target, 0.1);
		yangle = lerp(yangle, yangle_target, 0.1);
		zangle = lerp(zangle, zangle_target, 0.1);	
	}
	scale			= function(_scale) {
		xscale = _scale;	
		yscale = _scale;	
		zscale = _scale;		
	}
	cleanup			= function() {
		ds_map_destroy(group_map);
		ds_list_destroy(group_list);	
	}
}

