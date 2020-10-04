sprite_index	= choose(spr_vine_large, spr_vine_medium);
if (sprite_index == spr_vine_large)
	z		=  random_range(70, 150);
else
	z		=  random_range(-60, 20);
depth		=  0;
xscale		=  choose(image_xscale, -image_xscale);
yscale		=  image_yscale;
u_xscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_xscale");
u_yscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_yscale");
x += random(10);