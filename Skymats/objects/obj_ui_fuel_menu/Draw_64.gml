/// @description Draw Window and its contents

//Draw background
if (sprite_exists(sprite_background))
{
	draw_sprite_stretched(sprite_background, 0, pos_x, pos_y, width, height);
}

//Draw surface
if (!surface_exists(window_surface) && width > 0 && height > 7)
{
	window_surface = surface_create(width, height - 6);

	surface_set_target(window_surface);
	
	draw_clear_alpha(c_white, 0);

	//Current fuel
	draw_text_scribble(5, 16, "[scale, 2]Currently Burning");
	draw_set_color(c_gray);
	draw_rectangle(4 + 16, 4 + 16 + scroll_offset, 4 + 16 + 64, 4 + 16 + 64 + scroll_offset, false);
	draw_set_color(c_white);
	
	draw_sprite_ext(spr_items, ITEM_ID.coal, 4 + 16, 4 + 16 + scroll_offset, 2, 2, 0, c_white, 1);
	
	//Resource journal
	var _y = 128 + scroll_offset;
	for (var _i = 1; _i < ITEM_ID.last; _i++)
	{
		if (_i >= ITEM_ID.enemy_parts)
		{
			if (_i == ITEM_ID.enemy_parts)
			{
				draw_text_scribble(5, _y + _i*32 + 16, "[scale, 2]Enemy Drops");
				_y += 32+16;
			}
			
			
		}
		else if (_i == 1) draw_text_scribble(5, _y, "[scale, 2]Ores and Minerals");
		
		if (global.stored_resources_unlocked[_i])
		{
			draw_sprite(spr_items, _i, 5, _y + _i*32);
			draw_text(48, _y + 2 + _i*32, get_item_name(_i) + " x " + string(global.stored_resources[_i]));
			draw_text_scribble(200, _y + 2 + _i*32, "|[c_green] " + string(get_item_value(_i)) + "$ [c_white]|[c_red] %" + string(get_fuel_value(_i)/250) + " Fuel");
		}
		else
		{
			draw_sprite(spr_items, 0, 5, _y + _i*32);
			draw_text(48, _y + 2 + _i*32, "?????????????????????????????");
		}
	}

	surface_reset_target();
}

draw_set_alpha(window_alpha);

if (surface_exists(window_surface))
	draw_surface(window_surface, pos_x, pos_y + 3);

//Draw topbar
if (draw_topbar)
{
	draw_sprite_stretched(sprite_background, 0, pos_x, pos_y, width, _topbar_height);
}

//Draw scrollbar
if (scrollable && scroll_length > height)
{
	//background
	draw_rectangle_color(pos_x + width + 4, pos_y, pos_x + width + 4 + 4, pos_y + height, c_black, c_black, c_black, c_black, false);
	draw_rectangle_color(pos_x + width + 4, pos_y + scroll_offset*(scroll_offset/max_scroll_offset), pos_x + width + 4 + 4, pos_y + max(1, height-max_scroll_offset) + scroll_offset*(scroll_offset/max_scroll_offset), c_white, c_white, c_white, c_white, false);
}

//reset
draw_set_alpha(1);