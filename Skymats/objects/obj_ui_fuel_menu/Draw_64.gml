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
	var _y1 = 16 + scroll_offset;
	
	draw_text_scribble(width/2, _y1, "[font][scale, 2][fa_center]Fuel Management");
	
	_y1 += 128;
	
	var _selected_item_x = 500;
	
	draw_set_color(c_gray);
	draw_rectangle(_selected_item_x, 4 + _y1, _selected_item_x + 128, 4 + 128 + _y1, false);
	draw_set_color(c_white);
	
	draw_sprite_ext(spr_items, ITEM_ID.coal, _selected_item_x, 4 + _y1, 4, 4, 0, c_white, 1);
	
	//Resource journal
	var _y2 = _y1 + 256;
	
	for (var _i = 1; _i < ITEM_ID.last; _i++)
	{
		if (_i >= ITEM_ID.enemy_parts)
		{
			if (_i == ITEM_ID.enemy_parts)
			{
				draw_text_scribble(5, _y2 + _i*32 + 16, "[font]Enemy Drops");
				_y2 += 32+16;
			}
			
			
		}
		else if (_i == 1) draw_text_scribble(5, _y2, "[font]Ores and Minerals");
		
		if (global.stored_resources_auto_burn[_i])
			draw_sprite_stretched(spr_ui_burn_background, 0, 2, _y2 - 4 + _i*32, width-2, 34);
		
		if (global.stored_resources_unlocked[_i])
		{
			draw_sprite(spr_items, _i, 5, _y2 + _i*32);
			draw_text(48, _y2 + 2 + _i*32, get_item_name(_i) + " x " + string(global.stored_resources[_i]));
			draw_text_scribble(200, _y2 + 2 + _i*32, "|[c_green] " +
			string(get_item_value(_i)) + "$ [c_white]|[c_red] %" +
			string(get_fuel_value(_i)/250) + " Fuel[/c]"
			);
		}
		else
		{
			draw_sprite(spr_items, 0, 5, _y2 + _i*32);
			draw_text_scribble(48, _y2 + 2 + _i*32, "?????????????????????????????");
		}
	}
	
	//At this point in the code, _y2 is the bottom of the final grid space

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