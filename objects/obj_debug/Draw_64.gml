if (structures_show) {
	var _structure_data = structures[structure_index];
	
	draw_text(20, 20, _structure_data[2]);
	
	switch (_structure_data[1]) {
		case "list":
			var _list = _structure_data[0];
			for (var i = 0; i < ds_list_size(_list); i++) {
				var _id = _list[| i];
				draw_text(50, 50 + i * 15, string(_id) + " - " + string(object_get_name(_id.object_index)));	
			}
			break;
		
		case "grid":
			var _grid	= _structure_data[0];
			var _w		= ds_grid_width(_grid);
			var _h		= ds_grid_height(_grid);
			for (var i = 0; i < _w; i++) {
				for (var j = 0; j < _h; j++)
					draw_text(50 + i * 15, 50 + j * 15, _grid[# i, j]);
			}
			break;
	}
}