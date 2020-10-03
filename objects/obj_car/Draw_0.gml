draw_self();
draw_text(x, y, state.get_name());
draw_text(x, y + 10, facing);
draw_line(x + UNIT_SIZE / 2, y, x + (UNIT_SIZE / 2) + sight_dist_calm, y);