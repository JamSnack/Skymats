/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_player))
{
	var _p = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true);
	
	if (_p != noone)
	{
		//Accrue wealth
		for (var _i = 0; _i < global.inventory.size; _i++)
		{
			var _slot = global.inventory.contents[_i];
			
			if (!_slot.isEmpty() && _slot.amount > 0)
			{
				//Create wealth
				_p.gold += _slot.amount*get_item_value(_slot.item_id);
				
				//reset slot
				global.inventory.deleteItemAtSlot(_i);
			}
		}
		
		//Market stuff
		display_market_animation = lerp(display_market_animation, 1, 0.1);
	} 
	else display_market_animation = lerp(display_market_animation, 0, 0.1);
}
else display_market_animation = lerp(display_market_animation, 0, 0.1);