if (z_override != undefined)
	z		= z_override;
else
	z		= -1;
depth		=  0;
xscale		=  random_range(0.5, 1.5);
yscale		=  xscale;
u_xscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_xscale");
u_yscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_yscale");