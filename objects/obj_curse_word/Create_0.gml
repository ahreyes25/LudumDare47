if (z_override != undefined)
	z		= z_override;
else
	z		= -1;
depth		=  0;
xscale		=  choose(image_xscale, -image_xscale);
yscale		=  image_yscale;
u_xscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_xscale");
u_yscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_yscale");


texts = [
	"Oh damn!",
	"WTF",
	"WTH",
	"?!?!",
	"Is He Ok?",
	"D:",
	"HELP!",
	"OMG!",
	"Ahhh!",
	"Oh no...",
	"Dear God.",
];
text  = texts[irandom(array_length(texts) - 1)];
alpha = 1;
owner = undefined;
z_target = z - UNIT_SIZE * 3;
if (y < obj_grid.center_y)
	image_xscale = 0.8;
else
	image_xscale = -0.8;
image_yscale = 0.8;
