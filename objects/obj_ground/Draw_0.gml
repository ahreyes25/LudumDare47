matrix_set(matrix_world, matrix_build(x, y, z, xangle, yangle, zangle, xscale, yscale, zscale));
vertex_submit(vbuffer, primitive, sprite_get_texture(spr_texture_grass, 0));
matrix_set(matrix_world, matrix_build_identity());