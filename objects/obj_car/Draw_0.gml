if (SHOW_2D) {
	draw_self();	
	draw_text(x, y, state);
	draw_text(x, y + 10, "u: " + string(u) + ", v: " + string(v));
}