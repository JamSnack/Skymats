/// @description Insert description here
// You can write your code in this editor
if (animation_count < 1)
	animation_count += 0.01;
else lifetime -= 0.01;

if (lifetime < 0)
{
	instance_destroy();
	
	if (global.is_host)
		instance_create_layer(x, y, "Instances", obj_greed_collector, {target: target});
}