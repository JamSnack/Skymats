/// @description Insert description here
// You can write your code in this editor

function draw_widget(x, y)
{
	for (var _i = 1; _i < ITEM_ID.last; _i++)
	{
		if (_i >= ITEM_ID.enemy_parts)
		{
			if (_i == ITEM_ID.enemy_parts)
			{
				draw_text_scribble(5, y + _i*32 + 16, "[scale, 2]Enemy Drops");
				y += 32+16;
			}
			
			
		}
		else if (_i == 1) draw_text_scribble(5, y, "[scale, 2]Ores and Minerals");
		
		if (global.stored_resources_unlocked[_i])
		{
			draw_sprite(spr_items, _i, 5, y + _i*32);
			draw_text(48, y + 2 + _i*32, get_item_name(_i) + " x " + string(global.stored_resources[_i]));
			draw_text_scribble(200, y + 2 + _i*32, "|[c_green] " + string(get_item_value(_i)) + "$ [c_white]|[c_red] %" + string(get_fuel_value(_i)/250) + " Fuel");
		}
		else
		{
			draw_sprite(spr_items, 0, 5, y + _i*32);
			draw_text(48, y + 2 + _i*32, "?????????????????????????????");
		}
	}
}

length = 40*(ITEM_ID.last-1) + 32 + 16;