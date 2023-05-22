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
	
	for (var i=0; i<number_of_files; i++)
	{
		read_character(character_files[i]);
		draw_sprite(spr_player, 0, 4, 16*i);
		draw_text(48, i*16, "Gold: " + string(gold));
		draw_text(48, 16 + i*16, "Level: " + string(player_level));
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