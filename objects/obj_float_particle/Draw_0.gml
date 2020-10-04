image_alpha = life / life_base;
image_blend = merge_color(c_black, c_white, life / life_base);
draw_sprite_billboard_cylinder(sprite_index, image_index, x, y, z);	