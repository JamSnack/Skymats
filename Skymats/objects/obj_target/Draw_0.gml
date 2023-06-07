/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
gpu_set_fog(true, make_color_hsv(abs(255*sin(current_time/5000)), 100, 255), 0, 1);
event_inherited();
gpu_set_fog(false, c_white, 0, 0)