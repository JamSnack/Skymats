/// @description Draw Window and its contents

//Draw background
if (sprite_exists(sprite_background))
{
	draw_sprite_stretched(sprite_background, 0, pos_x, pos_y, width, height);
}

//Draw to content surface
if (!surface_exists(content_surface))
{
	content_surface = surface_create(width, height - 6);
	draw_item_index = 1;
	
	surface_set_target(content_surface);
	draw_clear_alpha(c_white, 0);
	surface_reset_target();
}
else if (draw_item_index != ITEM_ID.last)
{
	surface_set_target(content_surface);
	
	repeat(5)
	{
		//Current fuel
		var _y1 = 16;
	
		draw_text_scribble(width/2, _y1, "[font][scale, 2][fa_center]Fuel Management");
	
		_y1 += 128;
	
		var _selected_item_x = 500;
	
		draw_set_color(c_gray);
		draw_rectangle(_selected_item_x, 4 + _y1, _selected_item_x + 128, 4 + 128 + _y1, false);
		draw_set_color(c_white);
	
		//Fuel efficiency and item to burn
		if (global.stored_resource_to_burn != 0)
		{
			draw_text_scribble(_selected_item_x + 64, _y1-20, "[font][fa_center][scale, 0.75]"+get_item_name(global.stored_resource_to_burn));
			draw_sprite_ext(spr_items, global.stored_resource_to_burn, _selected_item_x, 4 + _y1, 4, 4, 0, c_white, 1);
			draw_text_scribble(_selected_item_x + 128 + 20, _y1 + 64, "[font]"+string(global.stored_resources[global.stored_resource_to_burn]));
			draw_text_scribble(_selected_item_x + 64, _y1 + 150, "[font][fa_center]Fuel Efficiency: " + string(get_item_bonus_fuel(global.stored_resource_to_burn)) + "%");
		}
		else
		{
			draw_text_scribble(_selected_item_x + 64, _y1-20, "[font][fa_center][scale, 0.75][c_red]No Item Available[\c]");
			draw_text_scribble(_selected_item_x + 64, _y1 + 150, "[font][fa_center]Fuel Efficiency: 0%\n[scale, 0.5]Increase fuel efficiency by selecting an item to burn.");
		}
	
		draw_text_scribble(_selected_item_x + 64, _y1 + 136, "[font][fa_center][scale, 0.5]Consumption Chance: 100%");
	
		//Resource journal
		var max_fuel = obj_platform.max_fuel;
		var _y2 = _y1 + 256;
	
		var _i = draw_item_index;
	
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
		
		//Resource description
		if (global.stored_resources_unlocked[_i])
		{
			//Create item description
			var _str = "|[c_green] " +
			string(get_item_value(_i)) + "$ [c_white]|[c_red] %" +
			string(100*(get_fuel_value(_i)/max_fuel)) + " Fuel[/c] | " + 
			"[c_orange]"+string(get_item_bonus_fuel(_i)) + "% Efficiency[/c]";
			
			if (_i > ITEM_ID.stone && _i < ITEM_ID.enemy_parts)
			{
				var _ore_dist = global.ore_distribution[_i];
				if (_ore_dist != 0)
					_str += " | Height Found: " + string(-min(0, _ore_dist.low))
			}
			
			//Draw stuff
			draw_sprite(spr_items, _i, 5, _y2 + _i*32);
			draw_text(48, _y2 + 2 + _i*32, get_item_name(_i) + " x " + string(global.stored_resources[_i]));
			draw_text_scribble(200, _y2 + 2 + _i*32, _str);
		}
		else
		{
			draw_sprite(spr_items, 0, 5, _y2 + _i*32);
			draw_text_scribble(48, _y2 + 2 + _i*32, "?????????????????????????????");
		}

		draw_item_index++;
		
		if (draw_item_index == ITEM_ID.last)
			break;
	}
	
	surface_reset_target();
}


//Main draw
draw_set_alpha(window_alpha);

if (!surface_exists(window_surface))
	window_surface = surface_create(width, height - 6);

if (surface_exists(content_surface))
{
	surface_set_target(window_surface);
	draw_clear_alpha(c_white, 0);
	draw_surface(content_surface, 0, scroll_offset);
	surface_reset_target();
}

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