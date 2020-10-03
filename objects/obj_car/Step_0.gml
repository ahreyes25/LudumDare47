event_inherited();

if (keyboard_check_pressed(vk_space))
	state.change(car_state_accel);
	
if (keyboard_check_pressed(vk_enter))
	state.change(car_state_brake_soft);

if (keyboard_check_pressed(vk_shift))
	state.change(car_state_brake_hard);