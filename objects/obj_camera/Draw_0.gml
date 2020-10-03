//draw_clear(c_black);

switch (CAMERA_PERSPECTIVE) {
	case PERSPECTIVE.FIRST:	look_first_person();	break;
	case PERSPECTIVE.THIRD:	look_third_person();	break;
}

var _camera		= camera_get_active();
var _view_mat	= matrix_build_lookat(x, y, z, xto, yto, zto, 0, 1, 0);
camera_set_view_mat(_camera, _view_mat);

var _aspect_ratio	= window_get_width() / window_get_height();
var _proj_mat		= matrix_build_projection_perspective_fov(fov, _aspect_ratio, 1, 32000);
camera_set_proj_mat(_camera, _proj_mat);
camera_apply(_camera);

with (obj_debug)	event_perform(ev_draw, 0);

//gpu_set_cullmode(cull_clockwise);
//shader_set(shdr_simple_lighting);

//model.submit();

//shader_reset();
//gpu_set_cullmode(cull_noculling);

// Draw Billboard Objects
shader_set(shdr_billboard_cylinder);
with (obj_billboard_cylinder) {
	shader_set_uniform_f(u_xscale, xscale);
	shader_set_uniform_f(u_yscale, yscale);
	event_perform(ev_draw, 0);
}
shader_reset();

shader_set(shdr_billboard_sphere);
with (obj_billboard_sphere)	{
	shader_set_uniform_f(u_xscale, xscale);
	shader_set_uniform_f(u_yscale, yscale);
	event_perform(ev_draw, 0);
}
shader_reset();