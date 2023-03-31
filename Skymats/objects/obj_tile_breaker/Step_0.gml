/// @description Insert description here
// You can write your code in this editor
if time > 60*1
{
	var _c = collision_point(x, y, TILE, false, true);
	
	if (_c != noone)
	{
		with _c 
		{
			hp -= other.damage;
			
			if (hp <= 0)
			{
				if (other.drop_item)
					event_user(0);
				
				instance_destroy();
			}
		}
		
		if (global.is_host)
			instance_destroy();
	}
	
	time = 0;	
}
else time++;

lifetime--;

if (lifetime < 0)
{
	if (global.is_host)
		send_data({cmd: "destroy_tile", x: x, y: y}, connected_socket);
		
	instance_destroy();
}