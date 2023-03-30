/// @description Insert description here
// You can write your code in this editor
var _w = display_get_gui_width();
var _h = display_get_gui_height();

if (display_market_animation > 0)
{
	draw_set_alpha(display_market_animation);
	draw_rectangle_color(_w - 400, 30, _w - 30, 500, c_black, c_black, c_black, c_black, false);
	
	//Label
	draw_text_scribble(_w-230, 10, "[c_white][wave]Market");
	
	//Upgrades
	var _x = _w - 400 + 20;
	
	//- Grapple
	draw_text_scribble(_x, 30 + 10, "Grappling Hook \n  - Range\n  - Hook Speed\n  - Pull Strength");
	
	//- Mining Tool
	draw_text_scribble(_x, 30 + 86, "Mining Tool \n  - Strength\n  - Speed");
	
	//- Weapon
	draw_text_scribble(_x, 30 + 146, "Weapon \n  - Damage\n  - Speed\n  - Range\n  - Knockback");
	
	//- Jetpack
	draw_text_scribble(_x, 30 + 246, "Jetpack \n  - Fuel\n  - Force\n  - Cooldown Delay\n  - Regen Rate");
	
	//- Gold
	if (instance_exists(obj_player))
		draw_text_scribble(_w-260, 500 - 60, "Gold - " + string(obj_player.gold));
		
	//- Instructions
	draw_text_scribble(_w-411, 500 + 12, "Use Arrow Keys (up/down) or W/S to select.\nPress Enter to confirm purchase.");
	
	//reset
	draw_set_alpha(1);
}
