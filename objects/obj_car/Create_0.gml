event_inherited();

move_scale			= 1.0;
accel				= 0.05	* move_scale;
fric				= 0.01	* move_scale;
brake_speed_soft	= accel * move_scale;
brake_speed_hard	= 0.1	* move_scale;
brake_coast_speed	= 0.01	* move_scale;
move_speed			= 1.0	* move_scale;
hspd				= 0;
vspd				= 0;
turn_dir			= DIR.NONE;

sight_dist_calm			= UNIT_SIZE * 3;
sight_dist_emergency	= UNIT_SIZE * 1;

entity		= ENTITY.CAR;
state		= new Fsm(id);
car_states_init();

state.change(car_state_idle);

check_for_stoplight = function() {
	switch (facing) {
		case DIR.RIGHT:	return collision_line(x + UNIT_SIZE / 2, y, x + (UNIT_SIZE / 2) + sight_dist_calm, y, obj_stoplight, false, false);	break;
		case DIR.LEFT:	return collision_line(x - UNIT_SIZE / 2, y, x - (UNIT_SIZE / 2) - sight_dist_calm, y, obj_stoplight, false, false);	break;
		case DIR.UP:	return collision_line(x, y - UNIT_SIZE / 2, x, y - (UNIT_SIZE / 2) - sight_dist_calm, obj_stoplight, false, false);	break;
		case DIR.DOWN:	return collision_line(x, y + UNIT_SIZE / 2, x, y + (UNIT_SIZE / 2) + sight_dist_calm, obj_stoplight, false, false);	break;
	}	
}