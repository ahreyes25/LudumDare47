/// @function State(fsm, state_name)
function State(_fsm, _state_name) constructor {	
	_enter	= undefined;
	_loop	= undefined;
	_exit	= undefined;
	_name	= _state_name;
	ds_map_add(_fsm.state_map, _state_name, self);
}

/// @function Fsm(owner)
function Fsm(_owner) constructor {
	owner				= _owner;
	previous_states		= ds_queue_create();
	n_states_to_track	= 5;
	previous_state		= undefined;
	state				= undefined;
	next_state			= undefined;
	state_map			= ds_map_create();
	
	/// @function init(n_states);
	static init	= function(_n_states) {
		n_states_to_track = _n_states;
	};
	
	/// @function destroy(run_exit?);
	static destroy = function(_run_exit) {
		ds_queue_destroy(previous_states);
		ds_map_destroy(state_map);
		
		if (_run_exit)
			state._exit(owner);
	};
	
	/// @function change(state/state_name);
	static change = function(_state) {
		next_state = _state;
	};
	
	/// @function update();
	static update = function() {	
		if (next_state != undefined && next_state != noone) {
			_exit_state();
			_next_state();
		}
		else if (state != undefined && state != noone)
			state._loop(owner);
	};
	
	static _exit_state = function() {
		if (state != undefined && state != noone) {
			state._exit(owner);	
			_store_state();
		}
		state = undefined;
	};
	
	static _next_state = function() {
		state = next_state;
		state._enter(owner);
		next_state = undefined;
	};
	
	static _store_state = function() {
		ds_queue_enqueue(previous_states, state);
		if (ds_queue_size(previous_states) > n_states_to_track)
			ds_queue_dequeue(previous_states);
	}
		
	/// @function get_name();
	static get_name	= function() {
		if (state == undefined)
			return "";
		return string(state._name);	
	}
	
	/// @function get_state_from_name(state_name)
	static get_state_from_name = function(_state_name) {
		return state_map[? _state_name];
	}
}