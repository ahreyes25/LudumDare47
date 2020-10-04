check_to_place_piece();

var _left_pressed	= keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left);
var _right_pressed	= keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right);
var _up_pressed		= keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up);
var _down_pressed	= keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down);

if (_left_pressed)	move(1, DIR.LEFT);
if (_right_pressed) move(1, DIR.RIGHT);
if (_up_pressed)	move(1, DIR.UP);
if (_down_pressed)	move(1, DIR.DOWN);

if (placed_object != undefined) {
	var _coords = grid_to_world(u, v);
	//placed_object.x = _coords[0];
	//placed_object.y = _coords[1];
}
