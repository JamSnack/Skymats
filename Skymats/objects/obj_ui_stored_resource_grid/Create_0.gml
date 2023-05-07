/// @description Insert description here
// You can write your code in this editor

function draw_widget()
{
	var _amt=0;
	for (var _i = 1; _i < ITEM_ID.enemy_parts; _i++)
	{
		draw_sprite(spr_items, _i, 5, _i*32);
		_amt++;
	}
}

length = 40*(ITEM_ID.enemy_parts-1);