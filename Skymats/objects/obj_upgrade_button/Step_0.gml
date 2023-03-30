/// @description Insert description here
// You can write your code in this editor

if (instance_exists(obj_market) && obj_market.display_market_animation > 0.9)
	visible = true;
else visible = false;

// Inherit the parent event
event_inherited();

