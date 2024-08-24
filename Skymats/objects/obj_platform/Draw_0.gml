/// @description Insert description here
// You can write your code in this editor
if (draw_fuel < fuel)
	draw_rectangle_color( bbox_left + 5, bbox_top + 2, bbox_left + (bbox_right-bbox_left-2)*(fuel/max_fuel), bbox_bottom - 8, c_white, c_white, c_white, c_white, false);
	
draw_rectangle_color( bbox_left + 5, bbox_top + 2, bbox_left + (bbox_right-bbox_left-2)*(draw_fuel/max_fuel), bbox_bottom - 8, c_teal, c_yellow, c_yellow, c_teal, false);

//Draw self and damage
if (fall_rate > 0)
{
	var _red = max(0.1, 0.9-(approach_rate/approach_rate_max));
	var _color = make_color_rgb(255, 255*_red, 255*_red);
	draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, _color, 1);
}
else draw_self();

if (fall_rate > 0)
	draw_text_scribble(x, y-96, "[fa_center][spr_ui_warning]\n[blink][c_red]FALLING!");
else if (approach_dungeon)
	draw_text_scribble(x, y-96, "[fa_center][spr_ui_warning]\n[blink]Large Skymass Incoming");
else if (waiting_for_pilot)
	draw_text_scribble(x, y-96, "[fa_center][spr_ui_warning]\n[blink]Waiting for pilot...");
else if (obstruction)
	draw_text_scribble(x, y-96, "[fa_center][spr_ui_warning]\n[blink]OBSTRUCTED");
	
if (fuel > 1 && powered && power_delay <= 0 && !obstruction && !waiting_for_pilot && !approach_dungeon)
{
	draw_sprite(spr_platform_flame, irandom(4), bbox_left+14, bbox_bottom);
	draw_sprite(spr_platform_flame, irandom(4), x, bbox_bottom);
	draw_sprite(spr_platform_flame, irandom(4), bbox_right-15, bbox_bottom);
}
else if (powered)
{
	draw_sprite(spr_platform_flame_weak, irandom(4), bbox_left+14, bbox_bottom);
	draw_sprite(spr_platform_flame_weak, irandom(4), x, bbox_bottom);
	draw_sprite(spr_platform_flame_weak, irandom(4), bbox_right-15, bbox_bottom);
}

if (show_engine_tutorial)
{
	draw_set_halign(fa_center);
	draw_text_scribble(x, y - 64, "[font][scale, 0.5][pulse]Press [c_teal]'G'[/c] to [c_orange]toggle[/c] engines.");
	
	//reset
	draw_set_halign(fa_left);
}