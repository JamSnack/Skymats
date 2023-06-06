/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
gpu_set_fog(true, make_color_hsv(current_time/75, 100, 255), 0, 1);
event_inherited();
gpu_set_fog(false, c_white, 0, 0)