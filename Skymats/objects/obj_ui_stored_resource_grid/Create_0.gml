/// @description Insert description here
// You can write your code in this editor

function draw_widget()
{
	for (var _i = 1; _i < ITEM_ID.enemy_parts; _i++)
	{
		if (global.stored_resources_unlocked[_i])
		{
			draw_sprite(spr_items, _i, 5, _i*32);
			draw_text(48, 2 + _i*32, get_item_name(_i) + " x " + string(global.stored_resources[_i]));
		}
		else
		{
			draw_sprite(spr_items, 0, 5, _i*32);
			draw_text(48, 2 + _i*32, "???????????");
		}
	}
}

length = 40*(ITEM_ID.enemy_parts-1);