/// @description Insert description here
// You can write your code in this editor
if (global.is_host)
{
	vspd += GRAVITY*weight;

	var _p = instance_nearest(x, y, PLAYER);

	if (_p != noone)
	{
		_dist = distance_to_object(_p);	
	
		//Attract
		if (_dist < 64 || speed != 0)
		{
			x = lerp(x, _p.x, 0.3);
			y = lerp(y, _p.y, 0.3);
		}
	
		//Collect
		if (_dist < 4)
		{
			if (_p.object_index == obj_player)
			{		
				global.inventory.addItem("", item_id, 1);
			}
			else
			{
				var _s = {cmd: "add_item", amt: 1, item_id: item_id}
				send_data(_s, _p.connected_socket);	
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