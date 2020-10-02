enum PERSPECTIVE { FIRST, THIRD, NONE }

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

dotobj_init();

instance_create_depth(0, 0, depth, obj_debug);
instance_create_depth(0, 0, depth, obj_camera);

room_goto_next();