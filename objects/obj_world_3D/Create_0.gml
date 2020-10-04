z = 0;

street = global.street_model;
street.x = x;
street.y = y;
street.z = z;
street.scale(SCALE_3D + 5);

building = global.building_model;
building.x = x;
building.y = y;
building.z = z;
building.scale(SCALE_3D + 5);