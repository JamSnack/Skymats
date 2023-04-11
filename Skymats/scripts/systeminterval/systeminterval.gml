// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
#macro SYSTEM_INTERVAL 20

global.deactivatedInstances = ds_list_create();

function process_system_interval()
{
	static current_interval = 0;
	
	switch (current_interval)
	{
		case 0: { cull_object(TILE) } break;
		case 1: { process_culls()   } break;
	}
	
	current_interval++;
	if (current_interval > SYSTEM_INTERVAL) current_interval = 0;
}

function cull_object(object)
{
	var _cx = camera.x - 1366/2;
	var _cy = camera.y - 768/2;
	
	with (object)
	{
		var hpad = 2;
		var vpad = 2;
		var _bbox_left =   x - sprite_xoffset - hpad;
		var _bbox_top =    y - sprite_yoffset - vpad;
		var _bbox_right =  _bbox_left + sprite_width + hpad*2;
		var _bbox_bottom = _bbox_top + sprite_height + vpad*2;		
		
		var cull = !( (_bbox_left   < _cx)           &&
					  (_bbox_right  > _cx + 1366)    &&
					  (_bbox_top    < _cy)           &&
					  (_bbox_bottom > _cy + 768));
		
		if (cull)
		{
			instance_deactivate_object(id);
			ds_list_add(global.deactivatedInstances, [id, _bbox_left, _bbox_right, _bbox_top, _bbox_bottom]);
		}
	}
}

function process_culls()
{
	var _cx = camera.x - 1366/2;
	var _cy = camera.y - 768/2;
	
	var _i = 0;
	repeat(ds_list_size(global.deactivatedInstances))
	{
		var _inst = global.deactivatedInstances[| _i];
		var _cull = (
					( _inst[1] < _cx + 1366) &&
					( _inst[2] > _cx       ) &&
					( _inst[3] > _cy + 768 ) &&
					( _inst[4] < _cy)
					);
		if !(_cull)
		{
			instance_activate_object(_inst[0]);
			ds_list_delete(global.deactivatedInstances, _i--);
		}
		++_i;
	}
}