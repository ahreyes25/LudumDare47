z = -1;

model = dotobj_model_load_file("Traffic-Signal.obj", true, true);
model.scale(SCALE_3D * 1.25);
model.x = x;
model.y = y;
model.z = z;