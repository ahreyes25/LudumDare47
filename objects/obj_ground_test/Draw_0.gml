matrix_set(matrix_world, matrix_build(x, y, z, xangle, yangle, zangle, xscale, yscale, zscale));
vertex_submit(vbuffer, primitive, -1);
matrix_set(matrix_world, matrix_build_identity());