/// @function vertex_add_point(vbuffer, x, y, z, nx, ny, nz, utex, vtex, color, alpha)
function vertex_add_point(_vbuffer, _x, _y, _z, _nx, _ny, _nz, _utex, _vtex, _color, _alpha) {
	vertex_position_3d(_vbuffer, _x, _y, _z);
	vertex_normal(_vbuffer, _nx, _ny, _nz);
	vertex_color(_vbuffer, _color, _alpha);
	vertex_texcoord(_vbuffer, _utex, _vtex);
}

/// @function draw_sprite_billboard_cylinder(sprite, subimage, x, y, z)  
function draw_sprite_billboard_cylinder(_sprite, _subimage, _x, _y, _z) {
    matrix_set(matrix_world, matrix_build(_x, _y, _z, 0, 0, 0, 1, 1, 1));
    draw_sprite(_sprite, _subimage, 0, 0);
    matrix_set(matrix_world, matrix_build_identity());
}

/// @function draw_sprite_billboard_sphere(sprite, subimage, x, y, z)  
function draw_sprite_billboard_sphere(_sprite, _subimage, _x, _y, _z) {
    matrix_set(matrix_world, matrix_build(_x, _y, _z, 0, 0, 0, 1, 1, 1));
    draw_sprite(_sprite, _subimage, 0, 0);
    matrix_set(matrix_world, matrix_build_identity());
}
