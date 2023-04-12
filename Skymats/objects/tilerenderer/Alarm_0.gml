/// @description Insert description here
// You can write your code in this editor
if (instance_exists(obj_island_generator) || instance_exists(obj_ore_generator))
{
	visible = false;
	alarm[0] = 20;
}
else visible = true;