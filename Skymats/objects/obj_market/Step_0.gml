/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_player))
{
	var _p = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true);
	
	if (_p != noone)
	{
		if (global.inventory.held_value > 0)
			obj_chat_box.add("[c_lime]" + string(global.inventory.held_value) + " wealth acquired.");
		
		//Accrue wealth
		for (var _i = 0; _i < global.inventory.size; _i++)
		{
			var _slot = global.inventory.contents[_i];
			
			if (!_slot.isEmpty() && _slot.amount > 0)
			{
				var _gains=_slot.amount*get_item_value(_slot.item_id);
				
				//Create wealth
				_p.gold += _gains;
				
				
				//reset slot
				global.inventory.deleteItemAtSlot(_i);
				global.inventory.held_value = 0;
			}
		}
		
		//Market stuff
		display_market_animation = lerp(display_market_animation, 1, 0.1);
	} 
	else display_market_animation = lerp(display_market_animation, 0, 0.1);
}
else display_market_animation = lerp(display_market_animation, 0, 0.1);