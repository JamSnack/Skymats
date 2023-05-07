/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_player) && instance_exists(obj_platform))
{
	var _p = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true);
	
	if (_p != noone)
	{
		if (global.inventory.held_value > 0)
		{

			//Prepare fuel to be sent to host if multiplayer and client
			var client_fuel = 0;
			
			//Accrue wealth
			for (var _i = 0; _i < global.inventory.size; _i++)
			{ 
				var _slot = global.inventory.contents[_i];
			
				if (!_slot.isEmpty() && _slot.amount > 0)
				{
					var _gains=_slot.amount*get_item_value(_slot.item_id);
				
					//Create wealth
					_p.gold += _gains;
					
					//Store resources
					global.stored_resources[_slot.item_id] += _slot.amount;
					
					//item effect
					create_depot(_p.x, _p.y, _slot.item_id);
			
					//Add fuel to the platform
					var fuel_amt = _slot.amount*get_fuel_value(_slot.item_id);
					
					client_fuel += fuel_amt;
					obj_platform.fuel += fuel_amt;
						
					
					//if (obj_platform.fuel > obj_platform.max_fuel)
						//obj_platform.fuel = obj_platform.max_fuel;
				
					//reset slot
					global.inventory.deleteItemAtSlot(_i);
					global.inventory.held_value = 0;
				}
			}
			
			//Pot of Greed curse
			/*
			if (instance_exists(obj_greed_collector))
			{
				with (obj_greed_collector)
					if (target == _p)
					{
						instance_destroy();
						obj_chat_box.add("[c_purple]The Greed Collector has been dispelled!");
					}
			}
			*/
			//Send client fuel
			if (!global.is_host && global.multiplayer)
				send_data({ cmd: "request_fuel_added", amt: client_fuel});
			
			//Save game
			save_game();
		}
		
		//Market stuff
		//display_market_animation = lerp(display_market_animation, 1, 0.1);
	} 
	else display_market_animation = lerp(display_market_animation, 0, 0.1);
}
else 
{
	//Close everything
	display_market_animation = lerp(display_market_animation, 0, 0.1);
	
	if (instance_exists(obj_ui_fuel_menu))
		with (obj_ui_fuel_menu) instance_destroy();
	
}


if (point_in_rectangle(mouse_x, mouse_y, bbox_left, bbox_top, bbox_right, bbox_bottom))
{
	if (mouse_check_button_released(mb_left))
	{
		if (!instance_exists(obj_ui_fuel_menu))
		{
			var _w = instance_create_layer(455, -600, "Instances", obj_ui_fuel_menu);
			_w.widgets.add(instance_create_layer(0, 0, "Instances", obj_ui_stored_resource_grid));
		}
	}
}