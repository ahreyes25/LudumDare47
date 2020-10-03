function car_states_init() {
	car_state_idle				= new State(state, "idle");
	car_state_accel				= new State(state, "accel");
	car_state_coast				= new State(state, "coast");
	car_state_brake_soft		= new State(state, "brake_soft");
	car_state_brake_hard		= new State(state, "brake_hard");
	car_state_turn				= new State(state, "turn");
				
	#region Idle
	car_state_idle._enter		= function() {
		// Snap To Grid Space
		//x		= (x div UNIT_SIZE) * UNIT_SIZE + UNIT_SIZE / 2;
		//y		= (y div UNIT_SIZE) * UNIT_SIZE + UNIT_SIZE / 2;
		hspd	= 0;
		vspd	= 0;
		stop_target_x = undefined;
		stop_target_y = undefined;
	}
	car_state_idle._loop		= function() {}
	car_state_idle._exit		= function() {}
	#endregion
	#region Accel
	car_state_accel._enter		= function() {}
	car_state_accel._loop		= function() {
		// Speed Up
		switch (facing) {
			case DIR.RIGHT:	hspd = lerp(hspd,  move_speed, accel);	break;	
			case DIR.LEFT:	hspd = lerp(hspd, -move_speed, accel);	break;	
			case DIR.UP:	vspd = lerp(vspd, -move_speed, accel);	break;	
			case DIR.DOWN:	vspd = lerp(vspd,  move_speed, accel);	break;	
		}
		
		var _stoplight = check_for_stoplight();
		if (_stoplight != noone && (_stoplight.light == "red" || _stoplight.light == "yellow")) {
			#region Start Coasting Towards Red Light
			if (_stoplight.light == "red") {
				switch (facing) {
					case DIR.RIGHT:	stop_target_x = _stoplight.x - UNIT_SIZE / 2;	break;
					case DIR.LEFT:	stop_target_x = _stoplight.x + UNIT_SIZE / 2;	break;
					case DIR.UP:	stop_target_y = _stoplight.y + UNIT_SIZE / 2;	break;
					case DIR.DOWN:	stop_target_y = _stoplight.y - UNIT_SIZE / 2;	break;
				}
			}
			#endregion
			#region Check To See If We Can Run Yellow Light Safely
			else if (_stoplight.light == "yellow") {
				switch (facing) {
					case DIR.RIGHT:	
						var _stop_target_x = _stoplight.x;
						var _time_to_stop  = abs(_stop_target_x - x) / hspd;
						if (_time_to_stop > _stoplight.alarm[0]) {
							stop_target_x = _stoplight.x - UNIT_SIZE / 2;
							state.change(car_state_coast);
						}
						break;
				}
			}
			#endregion
		}
		if (stop_target_x != undefined || stop_target_y != undefined)
			state.change(car_state_coast);
	}
	car_state_accel._exit		= function() {}
	#endregion
	#region Coast
	car_state_coast._enter		= function() {}
	car_state_coast._loop		= function() {
		hspd = lerp(hspd, 0, fric);
		vspd = lerp(vspd, 0, fric);
		
		switch (facing) {
			case DIR.RIGHT:
				var _time_to_stop  = abs(stop_target_x - x) / hspd;
				if (_time_to_stop > _stoplight.alarm[0]) {
					stop_target_x = _stoplight.x - UNIT_SIZE / 2;
					state.change(car_state_coast);
				}
				break;
		}
	}
	car_state_coast._exit		= function() {}
	#endregion
	#region Brake Soft
	car_state_brake_soft._enter	= function() {}
	car_state_brake_soft._loop	= function() {
		hspd = lerp(hspd, 0, brake_speed_soft);
		vspd = lerp(vspd, 0, brake_speed_soft);
		
		if (hspd <= 0.01 && vspd <= 0.01)
			state.change(car_state_idle);
	}
	car_state_brake_soft._exit	= function() {}
	#endregion
	#region Brake Hard
	car_state_brake_hard._enter	= function() {}
	car_state_brake_hard._loop	= function() {
		hspd = lerp(hspd, 0, brake_speed_hard);
		vspd = lerp(vspd, 0, brake_speed_hard);
		
		if (hspd <= 0.01 && vspd <= 0.01)
			state.change(car_state_idle);
	}
	car_state_brake_hard._exit	= function() {}
	#endregion
	#region Turn
	car_state_turn._enter		= function() {}
	car_state_turn._loop		= function() {}
	car_state_turn._exit		= function() {}
	#endregion
}

















