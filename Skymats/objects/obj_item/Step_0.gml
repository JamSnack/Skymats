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
			motion_add(point_direction(x, y, _p.x, _p.y), 0.5);
		}
	
		//Collect
		if (_dist < 4)
		{
			//TODO: add item to inventory based on whether or not dummy collected it
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


	calculate_collisions();

	//item pos
	send_data({cmd: "item_pos", x: x, y: y, connected_id: connected_id, item_id: item_id});
}
else
{
	x = lerp(x, target_x, 0.33);
	y = lerp(y, target_y, 0.33);
}