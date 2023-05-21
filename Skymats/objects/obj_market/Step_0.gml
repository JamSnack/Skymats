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
			var client_stash;
			var client_stash_size = 0;
			
			if (!global.is_host)
				client_stash = array_create(global.inventory.size);
			
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
					
					if (global.is_host)
					{
						if (global.stored_resources_unlocked[_slot.item_id] == 0)
						{
							global.stored_resources_unlocked[_slot.item_id] = 1;
							create_notification( "[wave][scale, 1.5]" + get_item_name(_slot.item_id) + " [spr_items, "+ string(_slot.item_id) + "] Discovered!");
						}
					}
					else
					{
						//Prepare structure with resource ID and amount to host for addition to the host's stash
						client_stash[client_stash_size++] = [_slot.item_id, _slot.amount];
					}
					
					
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
			{
				send_data({ cmd: "request_fuel_added", amt: client_fuel, stash: client_stash, size: client_stash_size});
			}
			
			//Save game
			save_game();
		}
		
		//Market stuff
		if (instance_exists(obj_ui_fuel_menu))
			display_market_animation = lerp(display_market_animation, 1, 0.1);
		else display_market_animation = lerp(display_market_animation, 0, 0.1);
		
		//Heal the player
		if (heal_delay <= 0 && _p.hp < _p.max_hp)
		{
			_p.hp++;
			heal_delay = 60*2;
		}
		else heal_delay--;
	} 
	else 
	{
		//Close everything
		display_market_animation = lerp(display_market_animation, 0, 0.1);
	
		instance_destroy_safe(obj_ui_fuel_menu);
	}
}