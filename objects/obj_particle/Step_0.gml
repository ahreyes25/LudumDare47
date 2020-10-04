iter += iter_speed;

var _points = bezier_quadratic_get_point(p1, p2, p3, iter);
var _p1		= _points[0];
var _p2		= _points[1];

if (dir == "x")
	x = x_start + _p1;
else if (dir == "y")
	y = y_start + _p1;
z = z_start + _p2;

if (z > 10)
	instance_destroy();