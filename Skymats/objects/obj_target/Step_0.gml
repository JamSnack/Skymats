draw_angle += 2*sign(random_factor);

if (hp < max_hp)
	hp = approach(hp, max_hp, 0.2);

event_inherited(); 