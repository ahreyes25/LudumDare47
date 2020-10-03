enum PERSPECTIVE { FIRST, THIRD, NONE }
enum DIR { LEFT = -1, RIGHT = 1, UP, DOWN, NONE }

display_reset(8, true);

gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);
gpu_set_tex_repeat(true);

// Turn Off For Performance Improvement
//gpu_set_tex_mip_enable(mip_on);
//gpu_set_tex_mip_filter(tf_anisotropic);
//gpu_set_tex_max_aniso(16);

global.camera_perspective = PERSPECTIVE.FIRST;
#macro CAMERA_PERSPECTIVE global.camera_perspective

global.unit_size = 24;
#macro UNIT_SIZE global.unit_size