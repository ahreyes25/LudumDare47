function car_states_init() {
	car_state_idle	= new State(state, "idle");	
	car_state_drive	= new State(state, "drive");	
	car_state_brake	= new State(state, "brake");	
	
	car_state_idle._enter	= function() {}
	car_state_idle._loop	= function() {}
	car_state_idle._exit	= function() {}

	car_state_drive._enter	= function() {
		
	}
	car_state_drive._loop	= function() {}
	car_state_drive._exit	= function() {}

	car_state_brake._enter	= function() {
		
	}
	car_state_brake._loop	= function() {}
	car_state_brake._exit	= function() {}
}