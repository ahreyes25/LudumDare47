z			=  0;
xangle		=  0;
yangle		=  0;
zangle		=  0;
xscale		=  1;
yscale		=  1;
zscale		=  1;

vbuffer		= vertex_create_buffer();
texture		= sprite_get_texture(spr_texture_grass, 0);
primitive	=  pr_trianglelist;

vertex_begin(vbuffer, VERTEX_FORMAT);
var _square_size = 32;
for (var i = 0; i < room_width; i += _square_size) {
	for (var j = 0; j < room_height; j += _square_size) {
		
		if ((i % (_square_size * 2) == 0 && j % (_square_size * 2) == 0) || (i % (_square_size * 2) > 0 && j % (_square_size * 2) > 0))
			var _col = c_gray;
		else
			var _col = c_white;
			
		vertex_add_point(vbuffer, i,				j,					0, 0, 0, 1,	0, 0,	_col, 1.0);
		vertex_add_point(vbuffer, i + _square_size,	j,					0, 0, 0, 1,	1, 0,	_col, 1.0);
		vertex_add_point(vbuffer, i + _square_size,	j + _square_size,	0, 0, 0, 1,	1, 1,	_col, 1.0);
																					
		vertex_add_point(vbuffer, i + _square_size,	j + _square_size,	0, 0, 0, 1,	1, 1,	_col, 1.0);
		vertex_add_point(vbuffer, i,				j + _square_size,	0, 0, 0, 1,	0, 1,	_col, 1.0);
		vertex_add_point(vbuffer, i,				j,					0, 0, 0, 1,	0, 0,	_col, 1.0);
	}
} 
vertex_end(vbuffer);