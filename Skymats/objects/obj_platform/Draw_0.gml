/// @description Insert description here
// You can write your code in this editor
if (draw_fuel < fuel)
	draw_rectangle_color( bbox_left + 5, bbox_top + 2, bbox_left + (bbox_right-bbox_left-2)*(fuel/max_fuel), bbox_bottom - 8, c_white, c_white, c_white, c_white, false);
	
draw_rectangle_color( bbox_left + 5, bbox_top + 2, bbox_left + (bbox_right-bbox_left-2)*(draw_fuel/max_fuel), bbox_bottom - 8, c_teal, c_yellow, c_yellow, c_teal, false);
draw_self();

if (approach_dungeon)
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