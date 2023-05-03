/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_player) && instance_exists(obj_platform))
{
	var _p = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true);
	
	if (_p != noone)
	{
		if (global.inventory.held_value > 0)
		{
			//Notify player
			obj_chat_box.add("[c_lime]" + string(global.inventory.held_value) + " wealth acquired.");
		
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
			if (instance_exists(obj_greed_collector))
			{
				with (obj_greed_collector)
					if (target == _p)
					{
						instance_destroy();
						obj_chat_box.add("[c_purple]The Greed Collector has been dispelled!");
					}
			}
			
			//Send client fuel
			if (!global.is_host && global.multiplayer)
				send_data({ cmd: "request_fuel_added", amt: client_fuel});
			
			//Save game
			with (_p)
			{
				var save_struct = {
					stat_grapple_force: stat_grapple_force,
					stat_grapple_range: stat_grapple_range,
					stat_grapple_speed: stat_grapple_speed,
					
					stat_jetpack_cooldown: stat_jetpack_cooldown,
					stat_jetpack_fuel: stat_jetpack_fuel,
					stat_jetpack_regen_rate: stat_jetpack_regen_rate,
					stat_jetpack_strength: stat_jetpack_strength,
					
					stat_mine_cooldown: stat_mine_cooldown,
					stat_mine_level: stat_mine_level,
					
					stat_weapon_cooldown: stat_weapon_cooldown,
					stat_weapon_damage: stat_weapon_damage,
					stat_weapon_knockback: stat_weapon_knockback,
					stat_weapon_range: stat_weapon_range,
					
					upgrades_purchased: upgrades_purchased,
					gold: gold,
					
					platform_height: global.platform_height
				}
				
				var json = json_stringify(save_struct);
				var _buff = buffer_create(string_byte_length(json) + 1, buffer_fixed, 1);
				buffer_write(_buff, buffer_string, json);
				buffer_save(_buff, "test.data");
	
				//cleanup
				buffer_delete(_buff);
			}
		}
		//Market stuff
		display_market_animation = lerp(display_market_animation, 1, 0.1);
	} 
	else display_market_animation = lerp(display_market_animation, 0, 0.1);
}
else display_market_animation = lerp(display_market_animation, 0, 0.1);