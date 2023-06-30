/// @description Insert description here
// You can write your code in this editor
/*
if (global.is_host)
{
	vspd += GRAVITY*weight;

	target = instance_nearest(x, y, PLAYER);

	if (target != noone)
	{
		_dist = distance_to_object(target);	
	
		//Attract
		if (_dist < 64 || speed != 0 || big_suck)
		{
			x = lerp(x, target.x, rate);
			y = lerp(y, target.y, rate);
			rate += 0.02;
		}
	
		//Collect
		if (_dist < 2)
		{
			if (target.object_index == obj_player)
			{		
				global.inventory.addItem(item_id, 1);
				create_floating_text(obj_player.x + irandom_range(-10, 10), obj_player.y - 10, "[scale, 0.5][wobble]+[spr_items, "+string(item_id)+"]");
				audio_play_sound_custom(choose(snd_item_pickup1, snd_item_pickup2, snd_item_pickup3, snd_item_pickup4, snd_item_pickup5), 10, false);
			}
			/*else if (global.multiplayer)
			{
				var _s = {cmd: "add_item", amt: 1, item_id: item_id}
				send_data(_s, target.connected_socket);	
			}
			
			instance_destroy();
		}
	}


	//calculate_collisions();

	//item pos
	send_data({cmd: "item_pos", x: x, y: y, connected_id: connected_id, item_id: item_id});
}
else
{
	sync_position();
	
	if (x == xprevious && y == yprevious)
		lifetime--;
	else lifetime = 30;
	
	if lifetime <= 0
		instance_destroy();
}
*/

vspd += GRAVITY*weight;

target = instance_nearest(x, y, PLAYER);

if (target != noone)
{
	_dist = distance_to_object(target);	
	
	//Attract
	if (_dist < 64 || speed != 0 || big_suck)
	{
		x = lerp(x, target.x, rate);
		y = lerp(y, target.y, rate);
		rate += 0.02;
	}
	
	//Collect
	if (_dist < 2)
	{
		if (target.object_index == obj_player)
		{		
			if (item_id != ITEM_ID.cash)
				global.inventory.addItem(item_id, 1);
			
			if (cash_value > 0)
			{
				obj_player.gold += cash_value;
				create_floating_text(obj_player.x + irandom_range(-10, 10), obj_player.y - 10, "[scale, 0.5][wobble][c_green]+$"+string(cash_value));
			}
			
			create_floating_text(obj_player.x + irandom_range(-10, 10), obj_player.y - 10, "[scale, 0.5][wobble]+[spr_items, "+string(item_id)+"]");
			audio_play_sound_custom(choose(snd_item_pickup1, snd_item_pickup2, snd_item_pickup3, snd_item_pickup4, snd_item_pickup5), 10, false);
		}
		
		instance_destroy();
	}
}

//lean
image_angle = lerp(image_angle, (xprevious-x)*10, 0.1);

//scaling
image_xscale = 0.75 + 0.05*dsin(current_time/1000);
image_yscale = 0.75 + 0.05*dsin(current_time/1000);