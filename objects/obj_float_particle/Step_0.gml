life -= SLOW_FACTOR;
z	 -= SLOW_FACTOR;

if (life <= 0)
	instance_destroy();
