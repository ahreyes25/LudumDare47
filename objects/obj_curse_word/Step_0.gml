alpha -= 0.01;

if (alpha <= 0.05)
	instance_destroy();
	
z = lerp(z, z_target, 0.05);