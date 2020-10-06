/// @description Restart Round

// Check For Victory!
var _robbers_dead	= false;
var _mailman_alive	= false;
var _all_alive		= false;
var _n_chars		= instance_number(obj_char);

// Save The Mailman
if (objectives_index == 0) {
	var _mailman_alive	= true;
	
	for (var i = 0; i < _n_chars; i++) {
		var _inst = instance_nth_nearest(0, 0, obj_char, i);
		if (_inst.image_index == 1) {
			if (_inst.dead)
				_mailman_alive = false;
		}
	}
}
// Kill The Robbers
else if (objectives_index == 1) {
	var _robbers_dead	= true;
	var _mailman_alive	= true;

	for (var i = 0; i < _n_chars; i++) {
		var _inst = instance_nth_nearest(0, 0, obj_char, i);
		// Robber
		if (_inst.image_index == 0) {
			if (!_inst.dead)
				_robbers_dead = false;
		}
		// Mailman
		else if (_inst.image_index == 1) {
			if (_inst.dead)
				_mailman_alive = false;
		}
	}
}
// Dont Let Civilians Die
else if (objectives_index == 2) {
	var _robbers_dead	= true;
	var _mailman_alive	= true;
	var _all_alive		= true;
	
	for (var i = 0; i < _n_chars; i++) {
		var _inst = instance_nth_nearest(0, 0, obj_char, i);
		// Robber
		if (_inst.image_index == 0) {
			if (!_inst.dead)
				_robbers_dead = false;
		}
		// Mailman
		else if (_inst.image_index == 1) {
			if (_inst.dead)
				_mailman_alive = false;
		}
		else if (_inst.dead)
			_all_alive = false;
	}
}

if (_robbers_dead && _mailman_alive && _all_alive) {
	show_message("Congrats! You Won!");
	game_won = true;
}
else if (objectives_index == 0 && _mailman_alive)
	objectives_index++;
else if (objectives_index == 1 && _mailman_alive && _robbers_dead)
	objectives_index++;

room_restart();