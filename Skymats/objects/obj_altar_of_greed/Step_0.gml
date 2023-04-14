/// @description Insert description here
// You can write your code in this editor
if (!pot_exists)
	instance_create_layer(x, y+8, "Instances", obj_pot_of_greed);
	
if (pot_timer > 0)
	pot_timer--;
else
{
	pot_exists = position_meeting(x, y+8, obj_pot_of_greed);
	pot_timer = 60*choose(5, 4, 3);
}
