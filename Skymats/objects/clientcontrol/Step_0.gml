/// @description Insert description here
// You can write your code in this editor
process_system_interval();
/*
frame++;
//TODO: Add frameskip subtlety setting
if (frame mod 10) == 0
	draw_enable_drawevent(false);
else draw_enable_drawevent(true);

if (frame > 1000)
	frame = 0;

//inventory_open_animation = approach(inventory_open_animation, inventory_open, 0.05);
/*
if (keyboard_check_released(vk_escape))
	inventory_open = !inventory_open;
	
//Hotbar

//- select nothing
if (keyboard_check_released(vk_lshift) || keyboard_check_released(vk_rshift))
	global.inventory.selected_slot = -1;
	
//- select an item
else if (keyboard_check_released(ord("0")))
	global.inventory.selected_slot = 9;
else if (keyboard_check_released(ord("1")))
	global.inventory.selected_slot = 0;
else if (keyboard_check_released(ord("2")))
	global.inventory.selected_slot = 1;
else if (keyboard_check_released(ord("3")))
	global.inventory.selected_slot = 2;
else if (keyboard_check_released(ord("4")))
	global.inventory.selected_slot = 3;
else if (keyboard_check_released(ord("5")))
	global.inventory.selected_slot = 4;
else if (keyboard_check_released(ord("6")))
	global.inventory.selected_slot = 5;
else if (keyboard_check_released(ord("7")))
	global.inventory.selected_slot = 6;
else if (keyboard_check_released(ord("8")))
	global.inventory.selected_slot = 7;
else if (keyboard_check_released(ord("9")))
	global.inventory.selected_slot = 8;
*/

//Get background colors
var _height = global.platform_height;
if (_height != last_height)
{
	background_colors = get_background_colors(-_height);
	height_range = background_colors[2];
	//show_debug_message(background_colors[0]);
	//show_debug_message(background_colors[1]);
	show_debug_message(background_colors[2]);
	last_height = _height;
}