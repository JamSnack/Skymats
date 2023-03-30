/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_player))
{
	var _p = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, obj_player, false, true);
	
	if (_p != noone)
	{
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
	}
}