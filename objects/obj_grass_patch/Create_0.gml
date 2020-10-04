z			= -1;
depth		=  0;
xscale		=  choose(image_xscale, -image_xscale);
yscale		=  image_yscale;
u_xscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_xscale");
u_yscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_yscale");