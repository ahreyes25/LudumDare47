state.update();

// Force Idle State If Stopped
//if (hspd == 0 && vspd == 0)
//	state.change(car_state_idle);

x += hspd;
y += vspd;