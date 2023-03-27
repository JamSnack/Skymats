/// @description Insert description here
// You can write your code in this editor

inventory_open_animation = approach(inventory_open_animation, inventory_open, 0.05);

if (keyboard_check_released(vk_escape))
	inventory_open = !inventory_open;
	
//Hotbar
if (keyboard_check_released(ord("0")))
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