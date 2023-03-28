/// @description Insert description here
// You can write your code in this editor

//Draw inventory
if (inventory_open_animation > 0)
{
	var inventory_open_evaluated = animcurve_channel_evaluate(inventory_open_animcurve_channel, inventory_open_animation);
	
	var _x = 1366/2 - 200;
	var _y = 710;
	var _size = 32;
	var _offset = 5;
	var row_size = 10;

	draw_set_color(c_white);

	for (var j = 0; j < global.inventory.size; j++)
	{
		var column = floor(j/row_size)*row_size;
		var _x1 = _x + ((j*(_size + _offset)) - (column*(_size + _offset)))*inventory_open_evaluated;
		var _y1 = _y + column*(_offset);
		var _x2 = _x + ((j*(_size + _offset)) - (column*(_size + _offset)) + _size)*inventory_open_evaluated;
		var _y2 = _y + column*(_offset) + _size;
		
		//inventory slots
		draw_rectangle_color( _x1, _y1, _x2, _y2, c_gray, c_gray, c_gray, c_gray, false);
						 
		//Selected slot
		if (global.inventory.selected_slot == j)
			draw_sprite(spr_ui_selected_slot, current_time/100, _x1, _y1);
				
		//inventory items
		var _item = global.inventory.contents[j];
	
		if (_item.item_id != 0)
		{
			draw_sprite(spr_items, _item.item_id, _x + ((j*(_size + _offset)) - (column*(_size + _offset)))*inventory_open_evaluated, _y + column*(_offset));
			draw_text(_x + ((j*(_size + _offset)) - (column*(_size + _offset)))*inventory_open_evaluated, _y + column*(_offset), string(_item.amount));
		}
	}
}