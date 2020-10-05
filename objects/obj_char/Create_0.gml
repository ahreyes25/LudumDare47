event_inherited();

entity		= ENTITY.CHAR;
image_index = irandom(image_number - 2);
image_speed	= 0;
z			= -1;
depth		=  0;
xscale		=  image_xscale;
yscale		=  image_yscale;
u_xscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_xscale");
u_yscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_yscale");
action		= undefined;