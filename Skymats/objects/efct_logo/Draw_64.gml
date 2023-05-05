/// @description Insert description here
// You can write your code in this editor

var _xscale = 1;
var _yscale = 1;
var _width = (_xscale)*54*time;
var _height =  (_yscale)*time*54;
var _x = display_get_gui_width()/2 - _width/2;
var _y = display_get_gui_height()/2 - 200 - _height/2;

draw_sprite_ext(spr_logo, 0, _x, _y, _xscale*time, _yscale*time, 4*sin(current_time/1000), c_white, time);