// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro SYSTEM_INTERVAL 10

function process_system_interval()
{
	static current_interval = 0;
	
	switch (current_interval)
	{
		case 0: { check_for_desync(); } break;
	}
	
	current_interval++;
	if (current_interval > SYSTEM_INTERVAL) current_interval = 0;
}

function check_for_desync()
{
	if (!global.is_host && !instance_exists(obj_client_request_chunk))
	{
		
	}
}