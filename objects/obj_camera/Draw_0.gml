var _cam_width  = window_get_width()  / 3;
var _cam_height = window_get_height() / 3;

//draw_clear(c_black);

//switch (CAMERA_PERSPECTIVE) {
//	case PERSPECTIVE.FIRST:	look_first_person();	break;
//	case PERSPECTIVE.THIRD:	look_third_person();	break;
//}

var _camera		= camera_get_active();
var _view_mat	= matrix_build_lookat(x, y, z, xto, yto, zto, 0, 0, 1);
camera_set_view_mat(_camera, _view_mat);

//var _aspect_ratio	= window_get_width() / window_get_height();
//var _proj_mat		= matrix_build_projection_perspective_fov(fov, _aspect_ratio, 1, 32000);
var _proj_mat		= matrix_build_projection_ortho(_cam_width, _cam_height, -32000, 32000);
camera_set_proj_mat(_camera, _proj_mat);
camera_apply(_camera);

if (!SHOW_2D) {
	with (obj_debug)		event_perform(ev_draw, 0);
	//with (obj_ground_test)	event_perform(ev_draw, 0);

	//gpu_set_cullmode(cull_clockwise);
	//shader_set(shdr_simple_lighting);

	with (obj_world_3D)	{
		base.submit();
		street.submit();
		building.submit();
		building2.submit();
		parking_lot.submit();
		water_tower.submit();
		hill.submit();
	}

	var _u_color = u_color;
	var _u_alpha = u_alpha;
	with (obj_car) {	
		if (show) {
			if (state == "crash") {
				shader_set(shdr_color_blend);
				var _r = color_get_red(CRASH_COLOR);
				var _g = color_get_green(CRASH_COLOR);
				var _b = color_get_blue(CRASH_COLOR);
				shader_set_uniform_f_array(_u_color, [_r, _g, _b]);
				shader_set_uniform_f(_u_alpha, 0.2);
			}
			model.submit();
			
			if (state == "crash")
				shader_reset();
		}
	}
	
	with (obj_piano) {
		if (state == "crash") {
			shader_set(shdr_color_blend);
			var _r = color_get_red(CRASH_COLOR);
			var _g = color_get_green(CRASH_COLOR);
			var _b = color_get_blue(CRASH_COLOR);
			shader_set_uniform_f_array(_u_color, [_r, _g, _b]);
			shader_set_uniform_f(_u_alpha, 0.2);
		}
		model.submit();
		
		if (state == "crash")
			shader_reset();
	}
	with (obj_stoplight_3D)	model.submit();	
	with (obj_dead_tree)	model.submit();
	with (obj_alive_tree)	model.submit();
	with (obj_ramp)			model.submit();

	//shader_reset();
	//gpu_set_cullmode(cull_noculling);

	// Draw Billboard Objects
	shader_set(shdr_billboard_cylinder);
	var _billboards = [obj_char, obj_vine_large, obj_vine_medium, obj_grass_patch, 
		obj_firehydrant, obj_stoplight_3D, obj_trashcan, obj_particle, obj_float_particle];
	for (var i = 0; i < array_length(_billboards); i++) {
		with (_billboards[i]) {
			shader_set_uniform_f(u_xscale, xscale);
			shader_set_uniform_f(u_yscale, yscale);
			event_perform(ev_draw, 0);
		}
	}
	shader_reset();
}