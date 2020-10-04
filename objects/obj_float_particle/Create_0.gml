z			= -1;
depth		=  0;
xscale		=  choose(image_xscale, -image_xscale);
yscale		=  image_yscale;
u_xscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_xscale");
u_yscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_yscale");

iter		= 0;
iter_speed	= 0.01;
height		= undefined;
life_base	= irandom_range(60 * 0.5, 60 * 1);
life		= life_base;