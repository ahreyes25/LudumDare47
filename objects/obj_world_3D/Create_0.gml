z = 0;

street = dotobj_model_load_file("Road.obj", true, true);
street.x = x;
street.y = y;
street.z = z;
street.scale(SCALE_3D + 5);

building = dotobj_model_load_file("Building-1.obj", true, false);
building.x = x;
building.y = y;
building.z = z;
building.scale(SCALE_3D + 5);