/// @description Insert description here
// You can write your code in this editor
pot_exists = instance_exists(my_pot);

if (!pot_exists && pot_timer <= 0)
{
	if (!checked_deactivated)
	{
		instance_activate_object(my_pot);
		checked_deactivated = true;
	}
	else
	{
		my_pot = instance_create_layer(x, y+8, "Instances", obj_pot_of_greed);
		pot_exists = true;
		checked_deactivated = false;
		pot_timer = 60*3;
	}
}
else 
{
	if !pot_exists && pot_timer > 0 then pot_timer--;
	
	checked_deactivated = false;
}