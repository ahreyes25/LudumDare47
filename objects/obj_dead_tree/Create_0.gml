z = -1;

model = new Model_Instance(global.dead_tree_model);
model.scale(SCALE_3D * 2);
model.x = x;
model.y = y;
model.z = z;

xscale		=  1;
yscale		=  1;
depth		=  0;
u_xscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_xscale");
u_yscale	=  shader_get_uniform(shdr_billboard_cylinder, "u_yscale");