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
	draw_text_scribble(_x, 30 + 10, "Grappling Hook" +
	"\n  - Range - " + string(get_upgrade_cost(1)) +
	"\n  - Hook Speed - " + string(get_upgrade_cost(2)) +
	"\n  - Pull Strength - " + string(get_upgrade_cost(3))
	);
	
	//- Mining Tool
	draw_text_scribble(_x, 30 + 86, "Mining Tool" + 
	"\n  - Strength - " + string(get_upgrade_cost(4)) +
	"\n  - Speed - "+ string(get_upgrade_cost(5))
	);
	
	//- Weapon
	draw_text_scribble(_x, 30 + 146, "Weapon" +  
	"\n  - Damage - " + string(get_upgrade_cost(6)) +
	"\n  - Speed - " + string(get_upgrade_cost(7)) +
	"\n  - Range - " + string(get_upgrade_cost(8)) +
	"\n  - Knockback - " + string(get_upgrade_cost(9)) 
	);
	
	//- Jetpack
	draw_text_scribble(_x, 30 + 246, "Jetpack" +  
	"\n  - Fuel - " + string(get_upgrade_cost(10)) +
	"\n  - Force - " + string(get_upgrade_cost(11)) +
	"\n  - Cooldown Delay - " + string(get_upgrade_cost(12)) +
	"\n  - Regen Rate - " + string(get_upgrade_cost(13))
	);
	
	//- Gold
	if (instance_exists(obj_player))
		draw_text_scribble(_w-260, 500 - 60, "Gold - " + string(obj_player.gold));
		
	//- Instructions
	draw_text_scribble(_w-411, 500 + 12, "Mouse over an upgrade you'd like to buy.\nLeft click to purchase it.");
	
	//reset
	draw_set_alpha(1);
}
