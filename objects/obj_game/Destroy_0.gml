ds_list_destroy(LIST_ENTITIES);
ds_grid_destroy(GRID_ENVIRONMENT);
ds_grid_destroy(GRID_LIGHTS);
ds_grid_destroy(GRID_CARS);
ds_grid_destroy(GRID_CHARS);

// Destroy Lists Stored In Grid First
for (var i = 0; i < ds_grid_width(GRID_CRASHES); i++) {
	for (var j = 0; j < ds_grid_height(GRID_CRASHES); j++) {
		var _value = GRID_CRASHES[# i, j];
		if (_value != undefined)
			ds_list_destroy(_value);
	}
}
ds_grid_destroy(GRID_CRASHES);
ds_list_destroy(car_colors);