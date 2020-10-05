if (obj_game.in_main_menu) {
	draw_sprite_ext(spr_title_con,		0, SW * 0.5, SH * 0.25, 5, 5, 0, c_white, 1);	
	draw_sprite_ext(spr_title_junction, 0, SW * 0.5, SH * 0.4,  8, 8, 0, c_white, 1);	
	
	var _b = c_black;
	var _s = 2;
	var _text_height = string_height("A") * _s;
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	
	if (!start_flicker)
		draw_text_transformed_color(SW * 0.5, SH * 0.66, "Press Enter", _s, _s, 0, _b, _b, _b, _b, 1); 
	draw_text_transformed_color(SW * 0.5, SH * 0.66 + _text_height, cleared_game == false ? "Press R To Reset Loop" : "Game Reset!", _s, _s, 0, _b, _b, _b, _b, 1); 

	var _s = 1;
	var _text_height = string_height("A") * _s;
	draw_text_transformed_color(SW * 0.5, SH - _text_height * 3, "Pixel Art: Aerys @_AERYS_", _s, _s, 0, _b, _b, _b, _b, 1);
	draw_text_transformed_color(SW * 0.5, SH - _text_height * 2, "3D Modeling: Anthony @nodesworth", _s, _s, 0, _b, _b, _b, _b, 1);
	draw_text_transformed_color(SW * 0.5, SH - _text_height * 1, "Programming: Alex @GentooGames", _s, _s, 0, _b, _b, _b, _b, 1);

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

if (show_controls) {
	var _width  = SW / sprite_get_width(spr_controls);
	var _height = SH / sprite_get_height(spr_controls);
	draw_sprite_ext(spr_controls, 0, 0, 0, _width, _height, 0, c_white, 1);
}