/// @description New Round FLicker

if (alarm[4] != -1) {
	new_round_flicker = !new_round_flicker;
	alarm[3] = new_round_flicker_count;
}