z = 0;

street = new Model_Instance(global.street_model);
street.x = x;
street.y = y;
street.z = z;
street.scale(SCALE_3D + 5);

building = new Model_Instance(global.building_model);
building.x = x;
building.y = y;
building.z = z;
building.scale(SCALE_3D + 5);

base = new Model_Instance(global.base_model);
base.x = x;
base.y = y;
base.z = z;
base.scale(SCALE_3D + 5);

building2 = new Model_Instance(global.building2_model);
building2.x = x;
building2.y = y;
building2.z = z;
building2.scale(SCALE_3D + 5);

parking_lot = new Model_Instance(global.parking_lot_model);
parking_lot.x = x;
parking_lot.y = y;
parking_lot.z = z;
parking_lot.scale(SCALE_3D + 5);

water_tower = new Model_Instance(global.water_tower_model);
water_tower.x = x;
water_tower.y = y + 80;
water_tower.z = z;
water_tower.scale(SCALE_3D + 5);

hill = new Model_Instance(global.hill_model);
hill.x = x;
hill.y = y;
hill.z = z;
hill.scale(SCALE_3D + 5);