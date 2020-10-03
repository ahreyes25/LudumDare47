show_debug_overlay(true);

structures = [
	[LIST_ENTITIES,		"list", "entities"],
	[GRID_ENVIRONMENT,	"grid", "environment"],
	[GRID_CARS,			"grid", "cars"],
	[GRID_CHARS,		"grid", "chars"],
	[GRID_LIGHTS,		"grid", "lights"],
];
structure_index = 0;
structures_show	= true;

/*
axis_x	= vertex_create_buffer();
axis_y	= vertex_create_buffer();
axis_z	= vertex_create_buffer();

vertex_begin(axis_x, VERTEX_FORMAT);
vertex_add_point(axis_x, -10000, 0, 0, 0, 0, 0, 0, 0, c_blue, 1);
vertex_add_point(axis_x,  10000, 0, 0, 0, 0, 0, 0, 0, c_blue, 1);
vertex_end(axis_x);

vertex_begin(axis_y, VERTEX_FORMAT);
vertex_add_point(axis_y, 0, -10000, 0, 0, 0, 0, 0, 0, c_red, 1);
vertex_add_point(axis_y, 0,  10000, 0, 0, 0, 0, 0, 0, c_red, 1);
vertex_end(axis_y);

vertex_begin(axis_z, VERTEX_FORMAT);
vertex_add_point(axis_z, 0, 0, -10000, 0, 0, 0, 0, 0, c_green, 1);
vertex_add_point(axis_z, 0, 0,  10000, 0, 0, 0, 0, 0, c_green, 1);
vertex_end(axis_z);