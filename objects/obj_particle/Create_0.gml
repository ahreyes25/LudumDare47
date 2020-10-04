z			= -1;
depth		=  0;
xscale		=  choose(image_xscale, -image_xscale);
yscale		=  image_yscale;
u_xscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_xscale");
u_yscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_yscale");

height	= undefined;
dist	= random_range(-20, 20);
x_start	= x;
y_start = y;
z_start = z;
dir		= choose("x", "y");
stored	= false;

iter		= 0;
iter_speed	= 0.01;