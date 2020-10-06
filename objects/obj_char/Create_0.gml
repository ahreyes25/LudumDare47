event_inherited();

entity		= ENTITY.CHAR;

if (skin == "random")
	image_index = irandom_range(2, image_number - 1);
else if (skin == "cop")
	image_index = 1;
else if (skin == "robber")
	image_index = 0;
image_speed	= 0;
z			= -1;
depth		=  0;
xscale		=  image_xscale;
yscale		=  image_yscale;
u_xscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_xscale");
u_yscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_yscale");
action		= undefined;
alarm0		= -1;
dead		= false;
top_x		= 0;
top_y		= 0;